-- GAP Retail Database - Transaction Data Generation Script
-- 05_transaction_tables.sql - Generating Comprehensive Order and Related Data
use gapdbase;
-- Disable safe mode and foreign key checks for efficient loading
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Start transaction for data integrity
START TRANSACTION;

-- -----------------------------------------------------
-- Preparation: Create Temporary Tables for Data Generation
-- -----------------------------------------------------

-- Temporary table to track order generation parameters
CREATE TEMPORARY TABLE order_generation_params (
    ParamName VARCHAR(50) PRIMARY KEY,
    ParamValue INT
);

-- Insert generation parameters
INSERT INTO order_generation_params (ParamName, ParamValue) VALUES
('TotalOrders', 5000),           -- Total number of orders to generate
('MaxItemsPerOrder', 5),          -- Maximum number of unique items per order
('MaxQuantityPerItem', 5),        -- Maximum quantity of a single item
('OrderDateSpan', 365),           -- Span of dates for order generation (days)
('ComplexityFactor', 3);          -- Controls randomness and complexity of orders

-- -----------------------------------------------------
-- Generate Orders
-- -----------------------------------------------------
INSERT INTO orders (
    CustomerID, 
    OrderDate, 
    OrderStatus, 
    ShippingAddressID, 
    BillingAddressID, 
    SubTotal, 
    TaxAmount, 
    ShippingAmount, 
    TotalAmount
)
WITH order_candidates AS (
    -- Select potential customers with addresses
    SELECT 
        c.CustomerID,
        a1.AddressID as ShippingAddressID,
        a2.AddressID as BillingAddressID,
        -- Randomize order dates within the past year
        DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * (
            SELECT ParamValue 
            FROM order_generation_params 
            WHERE ParamName = 'OrderDateSpan'
        )) DAY) as RandomOrderDate
    FROM 
        customers c
        JOIN addresses a1 ON c.CustomerID = a1.CustomerID AND a1.IsDefaultShipping = TRUE
        JOIN addresses a2 ON c.CustomerID = a2.CustomerID AND a2.IsDefaultBilling = TRUE
    -- Ensure customer has a default shipping and billing address
    WHERE 
        a1.AddressID IS NOT NULL 
        AND a2.AddressID IS NOT NULL
    ORDER BY 
        RAND()
    LIMIT (
        SELECT ParamValue 
        FROM order_generation_params 
        WHERE ParamName = 'TotalOrders'
    )
),
order_details AS (
    SELECT 
        oc.CustomerID,
        oc.ShippingAddressID,
        oc.BillingAddressID,
        oc.RandomOrderDate,
        -- Randomize order status
        ELT(
            FLOOR(1 + RAND() * 8), 
            'Pending', 'Processing', 'Ready for Pickup', 
            'Picked Up', 'Shipped', 'Delivered', 'Cancelled', 'Returned'
        ) as OrderStatus,
        -- Calculate subtotal, tax, and shipping dynamically
        ROUND(50 + (RAND() * 250), 2) as BaseSubTotal,
        -- Tax calculation (approximately 8%)
        ROUND((50 + (RAND() * 250)) * 0.08, 2) as BaseTaxAmount,
        -- Shipping calculation
        CASE 
            WHEN RAND() > 0.7 THEN 0.00  -- Free shipping
            ELSE ROUND(5.99 + (RAND() * 15), 2)
        END as ShippingAmount
    FROM 
        order_candidates oc
)
SELECT 
    CustomerID,
    RandomOrderDate as OrderDate,
    OrderStatus,
    ShippingAddressID,
    BillingAddressID,
    BaseSubTotal as SubTotal,
    BaseTaxAmount as TaxAmount,
    ShippingAmount,
    ROUND(BaseSubTotal + BaseTaxAmount + ShippingAmount, 2) as TotalAmount
FROM 
    order_details;

-- -----------------------------------------------------
-- Generate Order Items
-- -----------------------------------------------------
INSERT INTO order_items (
    OrderID, 
    ProductVariantID, 
    Quantity, 
    UnitPrice, 
    SubTotal
)
WITH available_variants AS (
    -- Select active product variants with inventory
    SELECT 
        pv.VariantID,
        pv.SKU,
        pv.VariantPrice,
        il.QuantityOnHand
    FROM 
        product_variants pv
        JOIN inventory_levels il ON pv.SKU = il.SKU
    WHERE 
        pv.IsActive = TRUE 
        AND il.QuantityOnHand > 0
),
order_item_candidates AS (
    -- Determine number of items per order
    SELECT 
        o.OrderID,
        FLOOR(1 + RAND() * (
            SELECT ParamValue 
            FROM order_generation_params 
            WHERE ParamName = 'MaxItemsPerOrder'
        )) as UniqueItemCount
    FROM 
        orders o
)
SELECT 
    oic.OrderID,
    av.VariantID as ProductVariantID,
    FLOOR(1 + RAND() * (
        SELECT ParamValue 
        FROM order_generation_params 
        WHERE ParamName = 'MaxQuantityPerItem'
    )) as Quantity,
    av.VariantPrice as UnitPrice,
    ROUND(
        av.VariantPrice * FLOOR(1 + RAND() * (
            SELECT ParamValue 
            FROM order_generation_params 
            WHERE ParamName = 'MaxQuantityPerItem'
        )), 
        2
    ) as SubTotal
FROM 
    order_item_candidates oic
    CROSS JOIN available_variants av
WHERE 
    -- Ensure unique items per order
    NOT EXISTS (
        SELECT 1 
        FROM order_items oi 
        WHERE oi.OrderID = oic.OrderID AND oi.ProductVariantID = av.VariantID
    )
    -- Limit to max items per order
    AND ROW_NUMBER() OVER (PARTITION BY oic.OrderID ORDER BY RAND()) <= oic.UniqueItemCount;

-- -----------------------------------------------------
-- Generate Payments
-- -----------------------------------------------------
INSERT INTO payments (
    OrderID, 
    PaymentMethodID, 
    PaymentStatusID, 
    Amount, 
    TransactionReference
)
SELECT 
    o.OrderID,
    -- Randomly select payment method
    pm.PaymentMethodID,
    -- Randomly select payment status
    ps.StatusID,
    o.TotalAmount,
    -- Generate unique transaction reference
    CONCAT(
        'TR', 
        LPAD(o.OrderID, 6, '0'), 
        LPAD(FLOOR(RAND() * 10000), 4, '0')
    ) as TransactionReference
FROM 
    orders o
    CROSS JOIN (
        SELECT PaymentMethodID 
        FROM payment_methods 
        WHERE IsActive = TRUE 
        ORDER BY RAND()
        LIMIT 1
    ) pm
    CROSS JOIN (
        SELECT StatusID 
        FROM payment_status 
        WHERE IsSystemStatus = TRUE 
        ORDER BY RAND()
        LIMIT 1
    ) ps;

-- -----------------------------------------------------
-- Generate Shipments
-- -----------------------------------------------------
INSERT INTO shipments (
    OrderID, 
    ShipmentType, 
    ShipmentStatus, 
    TrackingNumber, 
    ShippingCarrier,
    ShippedDate,
    EstimatedDeliveryDate,
    ActualDeliveryDate,
    PickupDate,
    PickupStoreID
)
WITH shipment_details AS (
    SELECT 
        o.OrderID,
        -- Randomly determine shipment type
        ELT(
            FLOOR(1 + RAND() * 3), 
            'Standard Shipping', 
            'Express Shipping', 
            'Store Pickup'
        ) as ShipmentType,
        -- Map shipment status based on order status
        CASE o.OrderStatus
            WHEN 'Pending' THEN 'Processing'
            WHEN 'Processing' THEN 'Processing'
            WHEN 'Ready for Pickup' THEN 'Ready for Pickup'
            WHEN 'Picked Up' THEN 'Picked Up'
            WHEN 'Shipped' THEN 'Shipped'
            WHEN 'Delivered' THEN 'Delivered'
            WHEN 'Cancelled' THEN 'Failed'
            WHEN 'Returned' THEN 'Failed'
            ELSE 'Processing'
        END as ShipmentStatus
    FROM 
        orders o
)
SELECT 
    sd.OrderID,
    sd.ShipmentType,
    sd.ShipmentStatus,
    -- Generate tracking number
    CONCAT(
        CASE 
            WHEN sd.ShipmentType = 'Standard Shipping' THEN 'GAP'
            WHEN sd.ShipmentType = 'Express Shipping' THEN 'GAPX'
            ELSE 'GAPPICKUP'
        END,
        LPAD(sd.OrderID, 6, '0'),
        LPAD(FLOOR(RAND() * 10000), 4, '0')
    ) as TrackingNumber,
    -- Randomly select shipping carrier
    ELT(
        FLOOR(1 + RAND() * 5), 
        'USPS', 'UPS', 'FedEx', 'DHL', 'OnTrac'
    ) as ShippingCarrier,
    -- Shipped date (for non-pickup orders)
    CASE 
        WHEN sd.ShipmentType != 'Store Pickup' THEN 
            DATE_ADD(o.OrderDate, INTERVAL FLOOR(1 + RAND() * 3) DAY)
    END as ShippedDate,
    -- Estimated delivery date
    CASE 
        WHEN sd.ShipmentType = 'Standard Shipping' THEN 
            DATE_ADD(o.OrderDate, INTERVAL FLOOR(5 + RAND() * 5) DAY)
        WHEN sd.ShipmentType = 'Express Shipping' THEN 
            DATE_ADD(o.OrderDate, INTERVAL FLOOR(2 + RAND() * 3) DAY)
        ELSE NULL
    END as EstimatedDeliveryDate,
    -- Actual delivery date (for delivered orders)
    CASE 
        WHEN sd.ShipmentStatus = 'Delivered' THEN 
            DATE_ADD(o.OrderDate, INTERVAL FLOOR(5 + RAND() * 5) DAY)
    END as ActualDeliveryDate,
    -- Pickup date (for store pickup)
    CASE 
        WHEN sd.ShipmentType = 'Store Pickup' THEN 
            DATE_ADD(o.OrderDate, INTERVAL FLOOR(1 + RAND() * 3) DAY)
    END as PickupDate,
    -- Select random store for pickup
    CASE 
        WHEN sd.ShipmentType = 'Store Pickup' THEN 
            (SELECT StoreID FROM stores WHERE IsActive = TRUE ORDER BY RAND() LIMIT 1)
    END as PickupStoreID
FROM 
    shipment_details sd
    JOIN orders o ON sd.OrderID = o.OrderID;

-- -----------------------------------------------------
-- Generate Shipment Items
-- -----------------------------------------------------
INSERT INTO shipment_items (
    ShipmentID, 
    OrderItemID, 
    Quantity
)
SELECT 
    s.ShipmentID,
    oi.OrderItemID,
    oi.Quantity
FROM 
    shipments s
    JOIN orders o ON s.OrderID = o.OrderID
    JOIN order_items oi ON o.OrderID = oi.OrderID;

-- -----------------------------------------------------
-- Clean Up Temporary Tables
-- -----------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS order_generation_params;

-- Re-enable foreign key checks and safe mode
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

-- Commit transaction
COMMIT;

-- End of 05_transaction_tables.sql
