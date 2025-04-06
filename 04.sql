-- GAP Retail Database - Data Population Script
-- 04_child_tables.sql - Populating Child/Junction Tables
-- This script populates tables that depend on the base tables and dependent tables
use gapdbase;
-- Disable safe mode for faster loading
SET SQL_SAFE_UPDATES = 0;

-- Temporarily disable foreign key checks for faster loading
SET FOREIGN_KEY_CHECKS = 0;

-- Start transaction for data integrity
START TRANSACTION;

-- -----------------------------------------------------
-- First, populate product_variants table (3000+ rows)
-- -----------------------------------------------------

-- Create temporary tables for colors and sizes
CREATE TEMPORARY TABLE temp_colors (
    color VARCHAR(50)
);

INSERT INTO temp_colors (color) VALUES 
('Black'), ('White'), ('Navy'), ('Grey'), ('Heather Grey'), ('Red'), ('Blue'), ('Light Blue'),
('Dark Blue'), ('Green'), ('Olive'), ('Khaki'), ('Beige'), ('Brown'), ('Tan'), ('Pink'), 
('Light Pink'), ('Purple'), ('Lavender'), ('Yellow'), ('Orange'), ('Burgundy'), ('Teal'), 
('Mint'), ('Coral'), ('Charcoal'), ('Ivory'), ('Denim'), ('Light Wash'), ('Medium Wash'), 
('Dark Wash'), ('Stripe'), ('Floral'), ('Plaid'), ('Polka Dot'), ('Camo'), ('Colorblock'), 
('Tie-Dye'), ('Animal Print'), ('Metallic');

CREATE TEMPORARY TABLE temp_sizes_apparel (
    size VARCHAR(20),
    size_order INT
);

INSERT INTO temp_sizes_apparel (size, size_order) VALUES 
('XXS', 1), ('XS', 2), ('S', 3), ('M', 4), ('L', 5), ('XL', 6), ('XXL', 7), ('3XL', 8);

CREATE TEMPORARY TABLE temp_sizes_numeric (
    size VARCHAR(20),
    size_order INT
);

INSERT INTO temp_sizes_numeric (size, size_order) VALUES 
('0', 1), ('2', 2), ('4', 3), ('6', 4), ('8', 5), ('10', 6), 
('12', 7), ('14', 8), ('16', 9), ('18', 10), ('20', 11);

CREATE TEMPORARY TABLE temp_sizes_jeans (
    size VARCHAR(20),
    size_order INT
);

INSERT INTO temp_sizes_jeans (size, size_order) VALUES 
('28x30', 1), ('28x32', 2), ('29x30', 3), ('29x32', 4), ('30x30', 5), ('30x32', 6), ('30x34', 7),
('31x30', 8), ('31x32', 9), ('31x34', 10), ('32x30', 11), ('32x32', 12), ('32x34', 13), ('32x36', 14),
('33x30', 15), ('33x32', 16), ('33x34', 17), ('33x36', 18), ('34x30', 19), ('34x32', 20), ('34x34', 21),
('34x36', 22), ('36x30', 23), ('36x32', 24), ('36x34', 25), ('36x36', 26), ('38x32', 27), ('38x34', 28),
('40x32', 29), ('40x34', 30), ('42x32', 31), ('42x34', 32);

-- Generate product variants efficiently
-- The approach is to create 3-8 color variants for each product
-- and for each color, create appropriate sizes based on product type
INSERT INTO product_variants (ProductID, SKU, Color, Size, VariantPrice, VariantImageURI, StockLevel, LowStockThreshold, Weight, IsActive)
WITH product_colors AS (
    -- For each product, select 3-8 random colors
    SELECT 
        p.ProductID,
        p.ProductName,
        p.MSRP,
        c.color,
        -- Create ranking of colors per product to limit to 3-8 colors
        ROW_NUMBER() OVER (PARTITION BY p.ProductID ORDER BY RAND()) as color_rank,
        -- Determine size table based on product type
        CASE 
            WHEN p.ProductName LIKE '%Jeans%' OR p.ProductName LIKE '%Pants%' OR p.ProductName LIKE '%Chinos%' THEN 'jeans'
            WHEN p.ProductName LIKE '%Dress%' OR p.ProductName LIKE '%Skirt%' THEN 'numeric'
            ELSE 'apparel'
        END as size_type
    FROM 
        products p
        CROSS JOIN temp_colors c
),
filtered_colors AS (
    -- Keep only 3-8 colors per product
    SELECT *
    FROM product_colors
    WHERE color_rank <= 3 + FLOOR(RAND() * 6)
)
-- Now join with appropriate size table based on product type and generate variants
SELECT 
    pc.ProductID,
    -- Create a SKU format: PPPPP-CC-SS (P=Product ID, C=Color code, S=Size code)
    CASE
        -- Different SKU formats based on size type
        WHEN pc.size_type = 'jeans' THEN 
            CONCAT('G', LPAD(pc.ProductID, 5, '0'), '-', UPPER(SUBSTRING(pc.color, 1, 2)), '-', s.size)
        WHEN pc.size_type = 'numeric' THEN
            CONCAT('G', LPAD(pc.ProductID, 5, '0'), '-', UPPER(SUBSTRING(pc.color, 1, 2)), '-', LPAD(s.size, 2, '0'))
        ELSE
            CONCAT('G', LPAD(pc.ProductID, 5, '0'), '-', UPPER(SUBSTRING(pc.color, 1, 2)), '-', s.size)
    END as SKU,
    pc.color,
    s.size,
    -- Base price + adjustment for size/color
    CASE
        WHEN s.size_order > 5 THEN pc.MSRP * (1 + (s.size_order - 5) * 0.05) -- Price increases for larger sizes
        ELSE pc.MSRP
    END as VariantPrice,
    -- Placeholder image URI based on product, color, size
    CONCAT('/images/products/', pc.ProductID, '/', 
           LOWER(REPLACE(pc.color, ' ', '-')), '/', 
           LOWER(REPLACE(s.size, ' ', '-')), '.jpg') as VariantImageURI,
    -- Random initial stock level
    FLOOR(10 + RAND() * 490) as StockLevel,
    -- Low stock threshold based on product popularity
    FLOOR(5 + RAND() * 20) as LowStockThreshold,
    -- Weight slightly varies by size
    p.Weight * (1 + (s.size_order * 0.05)) as Weight,
    -- Most variants are active, some are not
    CASE WHEN RAND() > 0.05 THEN 1 ELSE 0 END as IsActive
FROM 
    filtered_colors pc
    JOIN products p ON pc.ProductID = p.ProductID
    -- Join with appropriate size table based on product type
    LEFT JOIN (
        SELECT size, size_order FROM temp_sizes_apparel
        UNION ALL
        SELECT size, size_order FROM temp_sizes_numeric
        UNION ALL
        SELECT size, size_order FROM temp_sizes_jeans
    ) s ON 
    (
        (pc.size_type = 'apparel' AND s.size IN (SELECT size FROM temp_sizes_apparel)) OR
        (pc.size_type = 'numeric' AND s.size IN (SELECT size FROM temp_sizes_numeric)) OR
        (pc.size_type = 'jeans' AND s.size IN (SELECT size FROM temp_sizes_jeans))
    )
-- Ensure consistent generation by ordering
ORDER BY 
    pc.ProductID, pc.color_rank, s.size_order;

-- -----------------------------------------------------
-- Populate product_categories table (1000+ rows)
-- -----------------------------------------------------

-- Insert primary category for each product (already linked in the products table)
INSERT INTO product_categories (ProductID, CategoryID, IsPrimary)
SELECT 
    p.ProductID,
    p.CategoryID,
    TRUE -- Primary category
FROM 
    products p;

-- Add secondary categories for products (1-3 additional categories per product)
INSERT INTO product_categories (ProductID, CategoryID, IsPrimary)
WITH potential_categories AS (
    -- For each product, find potential secondary categories
    SELECT 
        p.ProductID,
        c.CategoryID,
        -- Exclude the product's primary category
        p.CategoryID as PrimaryCategoryID,
        -- Randomize for selection
        RAND() as random_order
    FROM 
        products p
        CROSS JOIN categories c
    WHERE 
        c.CategoryID <> p.CategoryID -- Exclude primary category
        AND c.IsActive = TRUE -- Only active categories
),
ranked_categories AS (
    -- Rank potential categories for each product
    SELECT 
        pc.*,
        ROW_NUMBER() OVER (PARTITION BY pc.ProductID ORDER BY pc.random_order) as category_rank
    FROM 
        potential_categories pc
)
-- Select 0-3 secondary categories per product
SELECT 
    rc.ProductID,
    rc.CategoryID,
    FALSE -- Not primary
FROM 
    ranked_categories rc
WHERE 
    rc.category_rank <= FLOOR(RAND() * 4) -- 0-3 secondary categories
    AND NOT EXISTS (
        -- Check for existing product-category relationship
        SELECT 1 FROM product_categories pc
        WHERE pc.ProductID = rc.ProductID AND pc.CategoryID = rc.CategoryID
    );

-- -----------------------------------------------------
-- Populate inventory_levels table (8000+ rows)
-- -----------------------------------------------------

-- Distribute inventory across warehouses and stores
-- For each product variant (SKU):
-- 1. Place inventory in 5-15 warehouses
-- 2. Place inventory in 10-40 stores

-- First, warehouse inventory
INSERT INTO inventory_levels (
    SKU, WarehouseID, StoreID, LocationType, QuantityOnHand, 
    ReservedForPickup, ReorderPoint, LastStockCheckDate
)
WITH warehouse_distribution AS (
    -- Select 5-15 random warehouses for each SKU
    SELECT 
        pv.SKU,
        w.WarehouseID,
        -- Rank warehouses per SKU to limit selection
        ROW_NUMBER() OVER (PARTITION BY pv.SKU ORDER BY RAND()) as warehouse_rank,
        -- Base quantity for this SKU
        pv.StockLevel as BaseStock
    FROM 
        product_variants pv
        CROSS JOIN warehouses w
    WHERE 
        pv.IsActive = TRUE
)
SELECT 
    wd.SKU,
    wd.WarehouseID,
    NULL as StoreID, -- No store for warehouse inventory
    'Warehouse' as LocationType,
    -- Distribute stock across warehouses, with main warehouses getting more
    CASE 
        WHEN wd.warehouse_rank = 1 THEN FLOOR(wd.BaseStock * 0.3) -- Main warehouse gets 30%
        WHEN wd.warehouse_rank <= 3 THEN FLOOR(wd.BaseStock * 0.15) -- Next 2 get 15% each
        ELSE FLOOR((wd.BaseStock * 0.4) / (wd.warehouse_rank - 3)) -- Rest share remaining 40%
    END as QuantityOnHand,
    0 as ReservedForPickup, -- No pickup reservations for warehouses
    -- Reorder point is proportional to quantity
    CASE 
        WHEN wd.warehouse_rank = 1 THEN FLOOR(wd.BaseStock * 0.3 * 0.2) -- 20% of quantity
        WHEN wd.warehouse_rank <= 3 THEN FLOOR(wd.BaseStock * 0.15 * 0.2)
        ELSE FLOOR((wd.BaseStock * 0.4 * 0.2) / (wd.warehouse_rank - 3))
    END as ReorderPoint,
    -- Last stock check was 0-30 days ago
    DATE_SUB(CURRENT_TIMESTAMP, INTERVAL FLOOR(RAND() * 30) DAY) as LastStockCheckDate
FROM 
    warehouse_distribution wd
WHERE 
    wd.warehouse_rank <= 5 + FLOOR(RAND() * 11); -- 5-15 warehouses per SKU

-- Now, store inventory
INSERT INTO inventory_levels (
    SKU, WarehouseID, StoreID, LocationType, QuantityOnHand, 
    ReservedForPickup, PickupReservationExpiry, ReorderPoint, LastStockCheckDate
)
WITH store_distribution AS (
    -- Select 10-40 random stores for each SKU
    SELECT 
        pv.SKU,
        s.StoreID,
        s.StoreSize, -- Store size affects inventory levels
        -- Rank stores per SKU to limit selection
        ROW_NUMBER() OVER (PARTITION BY pv.SKU ORDER BY RAND()) as store_rank,
        -- Base quantity at store level is lower than warehouse
        FLOOR(pv.StockLevel * 0.1) as BaseStoreStock -- 10% of variant stock level
    FROM 
        product_variants pv
        CROSS JOIN stores s
    WHERE 
        pv.IsActive = TRUE
        AND s.IsActive = TRUE
)
SELECT 
    sd.SKU,
    NULL as WarehouseID, -- No warehouse for store inventory
    sd.StoreID,
    'Store' as LocationType,
    -- Distribute stock based on store size and ranking
    CASE 
        -- Larger stores get more inventory
        WHEN sd.StoreSize > 9000 THEN FLOOR(sd.BaseStoreStock * 1.5)
        WHEN sd.StoreSize > 7000 THEN sd.BaseStoreStock
        ELSE FLOOR(sd.BaseStoreStock * 0.7)
    END as QuantityOnHand,
    -- Some items are reserved for pickup
    CASE 
        WHEN RAND() > 0.8 THEN FLOOR(RAND() * 3) -- 20% chance of having pickup reservations
        ELSE 0
    END as ReservedForPickup,
    -- Reservation expiry is 1-3 days in the future
    CASE 
        WHEN RAND() > 0.8 THEN DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (1 + FLOOR(RAND() * 3)) DAY)
        ELSE NULL
    END as PickupReservationExpiry,
    -- Reorder point is proportional to quantity
    CASE 
        WHEN sd.StoreSize > 9000 THEN FLOOR(sd.BaseStoreStock * 1.5 * 0.2)
        WHEN sd.StoreSize > 7000 THEN FLOOR(sd.BaseStoreStock * 0.2)
        ELSE FLOOR(sd.BaseStoreStock * 0.7 * 0.2)
    END as ReorderPoint,
    -- Last stock check was 0-14 days ago
    DATE_SUB(CURRENT_TIMESTAMP, INTERVAL FLOOR(RAND() * 14) DAY) as LastStockCheckDate
FROM 
    store_distribution sd
WHERE 
    sd.store_rank <= 10 + FLOOR(RAND() * 31); -- 10-40 stores per SKU

-- -----------------------------------------------------
-- Populate shopping_cart_items table (500+ rows)
-- -----------------------------------------------------

-- Generate shopping cart items
-- For each cart: 
-- 1. Add 1-5 items
-- 2. Vary quantities (1-5 per item)
-- 3. Ensure the variant exists and has stock

INSERT INTO shopping_cart_items (CartID, ProductVariantID, Quantity)
WITH cart_item_counts AS (
    -- Determine how many items to add to each cart (1-5)
    SELECT 
        sc.CartID,
        FLOOR(1 + RAND() * 5) as ItemCount
    FROM 
        shopping_cart sc
),
cart_items AS (
    -- Generate appropriate number of placeholder rows per cart
    SELECT 
        cic.CartID,
        ROW_NUMBER() OVER (PARTITION BY cic.CartID ORDER BY RAND()) as ItemNumber
    FROM 
        cart_item_counts cic
        CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) as nums
    WHERE 
        nums.1 <= cic.ItemCount
)
SELECT 
    ci.CartID,
    -- Select a random product variant that has inventory
    (
        SELECT pv.VariantID
        FROM product_variants pv
        JOIN inventory_levels il ON pv.SKU = il.SKU
        WHERE 
            pv.IsActive = TRUE 
            AND il.QuantityOnHand > 0
        ORDER BY RAND()
        LIMIT 1
    ) as ProductVariantID,
    -- Random quantity between 1 and 5
    FLOOR(1 + RAND() * 5) as Quantity
FROM 
    cart_items ci;

-- Clean up temporary tables
DROP TEMPORARY TABLE IF EXISTS temp_colors;
DROP TEMPORARY TABLE IF EXISTS temp_sizes_apparel;
DROP TEMPORARY TABLE IF EXISTS temp_sizes_numeric;
DROP TEMPORARY TABLE IF EXISTS temp_sizes_jeans;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Commit transaction to save data
COMMIT;

-- End of 04_child_tables.sql
-- Next file to be executed: 05_transaction_tables.sql
