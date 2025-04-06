-- GAP Retail Database - Data Population Script
-- 03_dependent_tables.sql - Populating Dependent Tables
-- This script populates tables that depend on the base independent tables
use gapdbase;
-- Disable safe mode for faster loading
SET SQL_SAFE_UPDATES = 0;

-- Temporarily disable foreign key checks for faster loading
SET FOREIGN_KEY_CHECKS = 0;

-- Start transaction for data integrity
START TRANSACTION;

-- -----------------------------------------------------
-- First, we need to populate customers table (since it's needed for addresses, loyalty_accounts, shopping_cart)
-- -----------------------------------------------------

-- Create a temporary table for first names
CREATE TEMPORARY TABLE temp_first_names (
    first_name VARCHAR(50)
);

INSERT INTO temp_first_names (first_name) VALUES 
('James'), ('Mary'), ('John'), ('Patricia'), ('Robert'), ('Jennifer'), ('Michael'), ('Linda'), 
('William'), ('Elizabeth'), ('David'), ('Susan'), ('Richard'), ('Jessica'), ('Joseph'), ('Sarah'), 
('Thomas'), ('Karen'), ('Charles'), ('Nancy'), ('Christopher'), ('Lisa'), ('Daniel'), ('Margaret'), 
('Matthew'), ('Betty'), ('Anthony'), ('Sandra'), ('Mark'), ('Ashley'), ('Donald'), ('Dorothy'), 
('Steven'), ('Kimberly'), ('Andrew'), ('Emily'), ('Paul'), ('Donna'), ('Joshua'), ('Michelle'), 
('Kenneth'), ('Carol'), ('Kevin'), ('Amanda'), ('Brian'), ('Melissa'), ('George'), ('Deborah'), 
('Timothy'), ('Stephanie'), ('Ronald'), ('Rebecca'), ('Jason'), ('Laura'), ('Edward'), ('Sharon'), 
('Jeffrey'), ('Cynthia'), ('Ryan'), ('Kathleen'), ('Jacob'), ('Amy'), ('Gary'), ('Shirley'), 
('Nicholas'), ('Angela'), ('Eric'), ('Helen'), ('Jonathan'), ('Anna'), ('Stephen'), ('Brenda'), 
('Larry'), ('Pamela'), ('Justin'), ('Nicole'), ('Scott'), ('Samantha'), ('Brandon'), ('Katherine'), 
('Benjamin'), ('Emma'), ('Samuel'), ('Ruth'), ('Gregory'), ('Christine'), ('Alexander'), ('Catherine'), 
('Patrick'), ('Debra'), ('Frank'), ('Rachel'), ('Raymond'), ('Carolyn'), ('Jack'), ('Janet'), 
('Dennis'), ('Virginia'), ('Jerry'), ('Maria'), ('Tyler'), ('Heather'), ('Aaron'), ('Diane'), 
('Jose'), ('Julie'), ('Adam'), ('Joyce'), ('Nathan'), ('Victoria'), ('Henry'), ('Kelly'), 
('Zachary'), ('Christina'), ('Douglas'), ('Lauren'), ('Peter'), ('Joan'), ('Kyle'), ('Evelyn'), 
('Noah'), ('Olivia'), ('Ethan'), ('Judith'), ('Jeremy'), ('Megan'), ('Walter'), ('Cheryl'), 
('Christian'), ('Martha'), ('Keith'), ('Andrea'), ('Roger'), ('Frances'), ('Terry'), ('Hannah'), 
('Austin'), ('Jacqueline'), ('Sean'), ('Ann'), ('Gerald'), ('Jean'), ('Carl'), ('Alice'), 
('Harold'), ('Kathryn'), ('Dylan'), ('Gloria'), ('Arthur'), ('Teresa'), ('Lawrence'), ('Sara'), 
('Jordan'), ('Janice'), ('Jesse'), ('Marie'), ('Bryan'), ('Madison'), ('Billy'), ('Doris'), 
('Bruce'), ('Julia'), ('Gabriel'), ('Grace'), ('Joe'), ('Judy'), ('Logan'), ('Abigail'), 
('Alan'), ('Denise'), ('Juan'), ('Amber'), ('Albert'), ('Marilyn'), ('Willie'), ('Beverly'), 
('Elijah'), ('Danielle'), ('Wayne'), ('Theresa'), ('Randy'), ('Sophia'), ('Roy'), ('Diana'), 
('Vincent'), ('Brittany'), ('Ralph'), ('Natalie'), ('Eugene'), ('Isabella'), ('Russell'), ('Charlotte'), 
('Bobby'), ('Rose'), ('Philip'), ('Alexis'), ('Louis'), ('Kayla');

-- Create a temporary table for last names
CREATE TEMPORARY TABLE temp_last_names (
    last_name VARCHAR(50)
);

INSERT INTO temp_last_names (last_name) VALUES 
('Smith'), ('Johnson'), ('Williams'), ('Jones'), ('Brown'), ('Davis'), ('Miller'), ('Wilson'), 
('Moore'), ('Taylor'), ('Anderson'), ('Thomas'), ('Jackson'), ('White'), ('Harris'), ('Martin'), 
('Thompson'), ('Garcia'), ('Martinez'), ('Robinson'), ('Clark'), ('Rodriguez'), ('Lewis'), ('Lee'), 
('Walker'), ('Hall'), ('Allen'), ('Young'), ('Hernandez'), ('King'), ('Wright'), ('Lopez'), 
('Hill'), ('Scott'), ('Green'), ('Adams'), ('Baker'), ('Gonzalez'), ('Nelson'), ('Carter'), 
('Mitchell'), ('Perez'), ('Roberts'), ('Turner'), ('Phillips'), ('Campbell'), ('Parker'), ('Evans'), 
('Edwards'), ('Collins'), ('Stewart'), ('Sanchez'), ('Morris'), ('Rogers'), ('Reed'), ('Cook'), 
('Morgan'), ('Bell'), ('Murphy'), ('Bailey'), ('Rivera'), ('Cooper'), ('Richardson'), ('Cox'), 
('Howard'), ('Ward'), ('Torres'), ('Peterson'), ('Gray'), ('Ramirez'), ('James'), ('Watson'), 
('Brooks'), ('Kelly'), ('Sanders'), ('Price'), ('Bennett'), ('Wood'), ('Barnes'), ('Ross'), 
('Henderson'), ('Coleman'), ('Jenkins'), ('Perry'), ('Powell'), ('Long'), ('Patterson'), ('Hughes'), 
('Flores'), ('Washington'), ('Butler'), ('Simmons'), ('Foster'), ('Gonzales'), ('Bryant'), ('Alexander'), 
('Russell'), ('Griffin'), ('Diaz'), ('Hayes'), ('Myers'), ('Ford'), ('Hamilton'), ('Graham'), 
('Sullivan'), ('Wallace'), ('Woods'), ('Cole'), ('West'), ('Jordan'), ('Owens'), ('Reynolds'), 
('Fisher'), ('Ellis'), ('Harrison'), ('Gibson'), ('Mcdonald'), ('Cruz'), ('Marshall'), ('Ortiz'), 
('Gomez'), ('Murray'), ('Freeman'), ('Wells'), ('Webb'), ('Simpson'), ('Stevens'), ('Tucker'), 
('Porter'), ('Hunter'), ('Hicks'), ('Crawford'), ('Henry'), ('Boyd'), ('Mason'), ('Morales'), 
('Kennedy'), ('Warren'), ('Dixon'), ('Ramos'), ('Reyes'), ('Burns'), ('Gordon'), ('Shaw'), 
('Holmes'), ('Rice'), ('Robertson'), ('Hunt'), ('Black'), ('Daniels'), ('Palmer'), ('Mills'), 
('Nichols'), ('Grant'), ('Knight'), ('Ferguson'), ('Rose'), ('Stone'), ('Hawkins'), ('Dunn'), 
('Perkins'), ('Hudson'), ('Spencer'), ('Gardner'), ('Stephens'), ('Payne'), ('Pierce'), ('Berry'), 
('Matthews'), ('Arnold'), ('Wagner'), ('Willis'), ('Ray'), ('Watkins'), ('Olson'), ('Carroll'), 
('Duncan'), ('Snyder'), ('Hart'), ('Cunningham'), ('Bradley'), ('Lane'), ('Andrews'), ('Ruiz'), 
('Harper'), ('Fox'), ('Riley'), ('Armstrong'), ('Carpenter'), ('Weaver'), ('Greene'), ('Lawrence'), 
('Elliott'), ('Chavez'), ('Sims'), ('Austin'), ('Peters'), ('Kelley'), ('Franklin'), ('Lawson');

-- Create a temporary table for email domains
CREATE TEMPORARY TABLE temp_email_domains (
    domain VARCHAR(50)
);

INSERT INTO temp_email_domains (domain) VALUES 
('gmail.com'), ('yahoo.com'), ('hotmail.com'), ('outlook.com'), ('icloud.com'), 
('aol.com'), ('mail.com'), ('protonmail.com'), ('zoho.com'), ('yandex.com'),
('gmx.com'), ('live.com'), ('msn.com'), ('fastmail.com'), ('tutanota.com');

-- Generate 2000 customers efficiently using cross joins
INSERT INTO customers (FirstName, LastName, Email, Phone, DateJoined, DateOfBirth, Gender, PreferredLanguage, MarketingPreferences, IsActive)
SELECT 
    f.first_name,
    l.last_name,
    LOWER(CONCAT(SUBSTR(f.first_name, 1, 1), l.last_name, 
            FLOOR(RAND() * 1000), '@', e.domain)) AS Email,
    CONCAT('(', LPAD(FLOOR(RAND() * 1000), 3, '0'), ') ',
           LPAD(FLOOR(RAND() * 1000), 3, '0'), '-', 
           LPAD(FLOOR(RAND() * 10000), 4, '0')) AS Phone,
    DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 1825) DAY) AS DateJoined,
    DATE_SUB(CURRENT_DATE, INTERVAL (18 + FLOOR(RAND() * 60)) YEAR) AS DateOfBirth,
    ELT(FLOOR(RAND() * 3) + 1, 'Male', 'Female', 'Non-binary') AS Gender,
    ELT(FLOOR(RAND() * 5) + 1, 'en', 'es', 'fr', 'zh', 'de') AS PreferredLanguage,
    JSON_OBJECT(
        'email_offers', IF(RAND() > 0.3, 'true', 'false'),
        'sms_alerts', IF(RAND() > 0.5, 'true', 'false'),
        'app_notifications', IF(RAND() > 0.4, 'true', 'false'),
        'seasonal_catalogs', IF(RAND() > 0.7, 'true', 'false')
    ) AS MarketingPreferences,
    IF(RAND() > 0.05, 1, 0) AS IsActive
FROM 
    temp_first_names f
    CROSS JOIN temp_last_names l
    CROSS JOIN temp_email_domains e
LIMIT 2000;

-- -----------------------------------------------------
-- Now populate addresses table (2000+ rows)
-- -----------------------------------------------------

-- Create temporary tables for address components
CREATE TEMPORARY TABLE temp_streets (
    street VARCHAR(100)
);

INSERT INTO temp_streets (street) VALUES 
('Main St'), ('Oak Ave'), ('Park Rd'), ('Maple Ln'), ('Washington Blvd'), ('Cedar St'), 
('Lake Ave'), ('Elm St'), ('Pine St'), ('River Rd'), ('Highland Ave'), ('Forest Dr'), 
('Meadow Ln'), ('Valley Rd'), ('Mountain View Dr'), ('Sunset Blvd'), ('Spring St'), 
('Willow St'), ('Hill St'), ('Broadway'), ('Cherry St'), ('Church St'), ('Lincoln Ave'), 
('Franklin St'), ('Jefferson Ave'), ('Adams St'), ('Monroe St'), ('Madison Ave'), 
('Jackson St'), ('West St'), ('East St'), ('North St'), ('South St'), ('College St'), 
('University Ave'), ('Park Ave'), ('Central Ave'), ('Market St'), ('Union St'), 
('Water St'), ('Mill St'), ('Front St'), ('State St'), ('High St'), ('Court St'), 
('School St'), ('Academy St'), ('Green St'), ('Chestnut St'), ('Walnut St');

CREATE TEMPORARY TABLE temp_cities (
    city VARCHAR(100),
    state VARCHAR(50),
    postal_prefix VARCHAR(3)
);

INSERT INTO temp_cities (city, state, postal_prefix) VALUES 
('New York', 'NY', '100'), ('Los Angeles', 'CA', '900'), ('Chicago', 'IL', '606'), 
('Houston', 'TX', '770'), ('Phoenix', 'AZ', '850'), ('Philadelphia', 'PA', '191'), 
('San Antonio', 'TX', '782'), ('San Diego', 'CA', '921'), ('Dallas', 'TX', '752'), 
('San Jose', 'CA', '951'), ('Austin', 'TX', '787'), ('Jacksonville', 'FL', '322'), 
('Fort Worth', 'TX', '761'), ('Columbus', 'OH', '432'), ('San Francisco', 'CA', '941'), 
('Charlotte', 'NC', '282'), ('Indianapolis', 'IN', '462'), ('Seattle', 'WA', '981'), 
('Denver', 'CO', '802'), ('Washington', 'DC', '200'), ('Boston', 'MA', '021'), 
('El Paso', 'TX', '799'), ('Nashville', 'TN', '372'), ('Detroit', 'MI', '482'), 
('Portland', 'OR', '972'), ('Memphis', 'TN', '381'), ('Oklahoma City', 'OK', '731'), 
('Las Vegas', 'NV', '891'), ('Louisville', 'KY', '402'), ('Baltimore', 'MD', '212'),
('Milwaukee', 'WI', '532'), ('Albuquerque', 'NM', '871'), ('Tucson', 'AZ', '857'), 
('Fresno', 'CA', '937'), ('Sacramento', 'CA', '958'), ('Kansas City', 'MO', '641'), 
('Mesa', 'AZ', '852'), ('Atlanta', 'GA', '303'), ('Omaha', 'NE', '681'), 
('Colorado Springs', 'CO', '809'), ('Raleigh', 'NC', '276'), ('Miami', 'FL', '331'), 
('Long Beach', 'CA', '908'), ('Virginia Beach', 'VA', '234'), ('Oakland', 'CA', '946'), 
('Minneapolis', 'MN', '554'), ('Tampa', 'FL', '336'), ('Tulsa', 'OK', '741'), 
('Arlington', 'TX', '760');

-- Generate addresses efficiently
INSERT INTO addresses (CustomerID, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Country, IsDefaultShipping, IsDefaultBilling, AddressType, IsVerified)
SELECT 
    c.CustomerID,
    CONCAT(FLOOR(RAND() * 9999) + 1, ' ', s.street) AS AddressLine1,
    IF(RAND() > 0.7, CONCAT('Apt ', FLOOR(RAND() * 999) + 1), NULL) AS AddressLine2,
    ct.city,
    ct.state,
    CONCAT(ct.postal_prefix, LPAD(FLOOR(RAND() * 99), 2, '0')) AS PostalCode,
    'USA',
    IF(address_num = 1, 1, 0) AS IsDefaultShipping,
    IF(address_num = 1, 1, 0) AS IsDefaultBilling,
    CASE 
        WHEN address_num = 1 THEN 'HOME'
        WHEN address_num = 2 THEN 'BUSINESS'
        ELSE ELT(FLOOR(RAND() * 2) + 1, 'SHIPPING', 'BILLING')
    END AS AddressType,
    IF(RAND() > 0.1, 1, 0) AS IsVerified
FROM 
    (
        SELECT 
            CustomerID,
            address_num
        FROM 
            customers
            CROSS JOIN (
                SELECT 1 AS address_num UNION ALL
                SELECT 2 WHERE (RAND() > 0.5) UNION ALL
                SELECT 3 WHERE (RAND() > 0.8)
            ) AS nums
        ORDER BY 
            CustomerID, address_num
    ) AS c
    JOIN temp_streets s ON RAND() <= 1.0
    JOIN temp_cities ct ON RAND() <= 1.0
ORDER BY 
    RAND()
LIMIT 2500;

-- -----------------------------------------------------
-- Populate loyalty_accounts table (1000 rows)
-- -----------------------------------------------------
INSERT INTO loyalty_accounts (CustomerID, PointsBalance, TierLevel, TierStartDate, TierEndDate, LifetimePoints)
SELECT 
    CustomerID,
    FLOOR(RAND() * 10000) AS PointsBalance,
    ELT(FLOOR(RAND() * 4) + 1, 'Standard', 'Silver', 'Gold', 'Platinum') AS TierLevel,
    DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 365) DAY) AS TierStartDate,
    DATE_ADD(CURRENT_DATE, INTERVAL FLOOR(RAND() * 365) DAY) AS TierEndDate,
    FLOOR(RAND() * 50000) + 10000 AS LifetimePoints
FROM 
    customers
ORDER BY 
    RAND()
LIMIT 1000;

-- -----------------------------------------------------
-- Populate products table (500 rows)
-- -----------------------------------------------------

-- Create temporary table for product names and details
CREATE TEMPORARY TABLE temp_product_types (
    product_type VARCHAR(50),
    description_prefix VARCHAR(100)
);

INSERT INTO temp_product_types (product_type, description_prefix) VALUES
('T-Shirt', 'Classic cotton t-shirt with'),
('Jeans', 'Comfortable denim jeans with'),
('Dress', 'Stylish dress with'),
('Sweater', 'Warm knit sweater with'),
('Jacket', 'Durable jacket with'),
('Shorts', 'Casual shorts with'),
('Hoodie', 'Cozy hoodie with'),
('Polo Shirt', 'Classic polo shirt with'),
('Skirt', 'Fashionable skirt with'),
('Button-Up Shirt', 'Professional button-up shirt with'),
('Blazer', 'Elegant blazer with'),
('Sweatpants', 'Comfortable sweatpants with'),
('Cardigan', 'Soft cardigan with'),
('Tank Top', 'Essential tank top with'),
('Leggings', 'Stretchy leggings with'),
('Coat', 'Insulated coat with'),
('Sweatshirt', 'Casual sweatshirt with'),
('Blouse', 'Delicate blouse with'),
('Chinos', 'Classic chinos with'),
('Jumpsuit', 'Trendy jumpsuit with');

CREATE TEMPORARY TABLE temp_product_features (
    feature VARCHAR(100)
);

INSERT INTO temp_product_features (feature) VALUES
('a relaxed fit'), ('a slim fit'), ('a regular fit'), ('a loose fit'), ('a tailored fit'),
('a crew neck'), ('a v-neck'), ('a scoop neck'), ('a boat neck'), ('a turtleneck'),
('short sleeves'), ('long sleeves'), ('three-quarter sleeves'), ('no sleeves'), ('rolled sleeves'),
('button details'), ('pocket details'), ('embroidered details'), ('lace details'), ('ruffled details'),
('striped pattern'), ('floral pattern'), ('solid color'), ('plaid pattern'), ('polka dot pattern'),
('distressed finish'), ('faded finish'), ('stonewashed finish'), ('raw hem'), ('cropped fit'),
('high waist'), ('mid-rise waist'), ('low waist'), ('elastic waist'), ('drawstring waist'),
('stretch fabric'), ('organic cotton'), ('sustainable materials'), ('recycled materials'), ('premium materials');

CREATE TEMPORARY TABLE temp_product_adjectives (
    adjective VARCHAR(50)
);

INSERT INTO temp_product_adjectives (adjective) VALUES
('Classic'), ('Modern'), ('Vintage'), ('Essential'), ('Premium'),
('Signature'), ('Contemporary'), ('Trendy'), ('Timeless'), ('Stylish'),
('Luxury'), ('Casual'), ('Comfortable'), ('Elegant'), ('Relaxed'),
('Slim'), ('Oversized'), ('Traditional'), ('Designer'), ('Everyday');

CREATE TEMPORARY TABLE temp_product_brands (
    brand VARCHAR(50)
);

INSERT INTO temp_product_brands (brand) VALUES
('GAP'), ('GAP'), ('GAP'), ('GAP'), ('GAP'), -- More weight for GAP brand
('Old Navy'), ('Banana Republic'), ('Athleta'), ('Hill City'), ('Intermix'),
('Janie and Jack'), ('GAP Factory'), ('Banana Republic Factory'), ('Pipeline');

CREATE TEMPORARY TABLE temp_seasons (
    year INT,
    season VARCHAR(20)
);

INSERT INTO temp_seasons (year, season) VALUES
(2022, 'Spring'), (2022, 'Summer'), (2022, 'Fall'), (2022, 'Winter'),
(2023, 'Spring'), (2023, 'Summer'), (2023, 'Fall'), (2023, 'Winter'),
(2024, 'Spring'), (2024, 'Summer'), (2024, 'Fall'), (2024, 'Winter'),
(2025, 'Spring'), (2025, 'Summer');

-- Generate products efficiently
INSERT INTO products (ProductName, ProductDescription, Brand, CategoryID, SupplierID, 
                     ProductLifecycleStatus, MSRP, StandardCost, Weight, Dimensions, 
                     SeasonYear, SeasonName)
SELECT 
    CONCAT(
        adj.adjective, ' ',
        pt.product_type
    ) AS ProductName,
    CONCAT(
        pt.description_prefix, ' ', 
        f1.feature, ' and ', 
        f2.feature, '. Perfect for any occasion.'
    ) AS ProductDescription,
    b.brand AS Brand,
    -- Select a category that makes sense for the product type
    (
        SELECT CategoryID FROM categories 
        WHERE CategoryName IN (
            CASE 
                WHEN pt.product_type IN ('T-Shirt', 'Polo Shirt', 'Button-Up Shirt') THEN 'T-Shirts'
                WHEN pt.product_type IN ('Jeans') THEN 'Jeans'
                WHEN pt.product_type IN ('Dress') THEN 'Dresses'
                WHEN pt.product_type IN ('Sweater', 'Cardigan', 'Sweatshirt', 'Hoodie') THEN 'Sweaters'
                WHEN pt.product_type IN ('Jacket', 'Coat', 'Blazer') THEN 'Jackets & Coats'
                WHEN pt.product_type IN ('Shorts') THEN 'Shorts'
                WHEN pt.product_type IN ('Skirt', 'Jumpsuit', 'Blouse') THEN 'Tops'
                WHEN pt.product_type IN ('Sweatpants', 'Leggings', 'Chinos') THEN 'Pants'
                ELSE 'Tops' -- Default to Tops if no match
            END
        )
        ORDER BY RAND() 
        LIMIT 1
    ) AS CategoryID,
    s.SupplierID,
    ELT(FLOOR(RAND() * 4) + 1, 'Draft', 'Active', 'Discontinued', 'Seasonal') AS ProductLifecycleStatus,
    (19.99 + (RAND() * 100)) AS MSRP,
    ((19.99 + (RAND() * 100)) * 0.4) AS StandardCost,
    (0.2 + RAND() * 2) AS Weight,
    CONCAT(FLOOR(10 + RAND() * 40), 'x', FLOOR(10 + RAND() * 40), 'x', FLOOR(2 + RAND() * 8), 'cm') AS Dimensions,
    se.year AS SeasonYear,
    se.season AS SeasonName
FROM 
    temp_product_types pt
    CROSS JOIN temp_product_adjectives adj
    CROSS JOIN temp_product_features f1
    CROSS JOIN temp_product_features f2
    CROSS JOIN temp_product_brands b
    CROSS JOIN temp_seasons se
    JOIN suppliers s ON 1=1
WHERE 
    f1.feature != f2.feature
GROUP BY 
    pt.product_type, adj.adjective, b.brand, se.year, se.season
ORDER BY 
    RAND()
LIMIT 500;

-- -----------------------------------------------------
-- Populate promotions table (100+ rows)
-- -----------------------------------------------------

-- Create temporary table for promotion names and types
CREATE TEMPORARY TABLE temp_promo_types (
    promo_name VARCHAR(100),
    promo_description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT', 'BUY_X_GET_Y', 'BUNDLE')
);

INSERT INTO temp_promo_types (promo_name, promo_description, discount_type) VALUES
('Summer Sale', 'Special discounts on summer apparel and accessories', 'PERCENTAGE'),
('Winter Clearance', 'End of season clearance on winter items', 'PERCENTAGE'),
('Back to School', 'Special savings for back to school shopping', 'PERCENTAGE'),
('Holiday Special', 'Celebrate the holidays with special savings', 'PERCENTAGE'),
('Flash Sale', 'Limited time offer with deep discounts', 'PERCENTAGE'),
('Member Exclusive', 'Special offer for loyalty program members', 'PERCENTAGE'),
('First Purchase', 'Discount on your first purchase', 'PERCENTAGE'),
('Refer a Friend', 'Discount when you refer a friend', 'FIXED_AMOUNT'),
('Birthday Reward', 'Special discount during your birthday month', 'FIXED_AMOUNT'),
('Free Shipping', 'Free shipping on orders over a certain amount', 'FIXED_AMOUNT'),
('Buy One Get One Free', 'Purchase one item and get another free', 'BUY_X_GET_Y'),
('Buy One Get One 50% Off', 'Purchase one item and get another at half price', 'BUY_X_GET_Y'),
('Bundle Deal', 'Special pricing when purchasing multiple items', 'BUNDLE'),
('Loyalty Rewards', 'Special discount for loyal customers', 'PERCENTAGE'),
('Email Signup', 'Discount for joining our email list', 'PERCENTAGE'),
('App Download', 'Special offer for downloading our mobile app', 'FIXED_AMOUNT'),
('Social Media Follow', 'Discount for following us on social media', 'PERCENTAGE'),
('Weekend Special', 'Limited time offer valid only on weekends', 'PERCENTAGE'),
('New Arrival', 'Special pricing on new arrivals', 'PERCENTAGE'),
('Clearance Extra', 'Additional discount on clearance items', 'PERCENTAGE');

-- Generate promotions efficiently
INSERT INTO promotions (PromotionName, PromotionCode, Description, StartDate, EndDate, 
                       DiscountType, DiscountValue, MinimumPurchase, MaximumDiscount, 
                       UsageLimit, IsStackable, IsActive, ApplicableProducts, ExcludedProducts, 
                       TargetCustomerSegment)
SELECT 
    CONCAT(pt.promo_name, ' ', YEAR(CURRENT_DATE), 
           IF(RAND() > 0.5, CONCAT(' - ', MONTH(CURRENT_DATE)), '')) AS PromotionName,
    CONCAT(
        UPPER(SUBSTRING(REPLACE(pt.promo_name, ' ', ''), 1, 4)),
        YEAR(CURRENT_DATE),
        LPAD(FLOOR(RAND() * 1000), 3, '0')
    ) AS PromotionCode,
    pt.promo_description AS Description,
    DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 180) DAY) AS StartDate,
    DATE_ADD(CURRENT_DATE, INTERVAL FLOOR(RAND() * 180) DAY) AS EndDate,
    pt.discount_type AS DiscountType,
    CASE 
        WHEN pt.discount_type = 'PERCENTAGE' THEN FLOOR(5 + (RAND() * 50))
        WHEN pt.discount_type = 'FIXED_AMOUNT' THEN FLOOR(5 + (RAND() * 50))
        WHEN pt.discount_type = 'BUY_X_GET_Y' THEN FLOOR(1 + (RAND() * 3))
        ELSE FLOOR(5 + (RAND() * 30))
    END AS DiscountValue,
    IF(RAND() > 0.3, FLOOR(25 + (RAND() * 100)), NULL) AS MinimumPurchase,
    IF(RAND() > 0.5, FLOOR(50 + (RAND() * 200)), NULL) AS MaximumDiscount,
    IF(RAND() > 0.7, FLOOR(100 + (RAND() * 10000)), NULL) AS UsageLimit,
    IF(RAND() > 0.7, 1, 0) AS IsStackable,
    IF(RAND() > 0.2, 1, 0) AS IsActive,
    IF(RAND() > 0.5, 
        JSON_ARRAY(
            FLOOR(1 + (RAND() * 10)),
            FLOOR(1 + (RAND() * 10)),
            FLOOR(1 + (RAND() * 10))
        ), 
        NULL
    ) AS ApplicableProducts,
    IF(RAND() > 0.7, 
        JSON_ARRAY(
            FLOOR(1 + (RAND() * 10)),
            FLOOR(1 + (RAND() * 10))
        ), 
        NULL
    ) AS ExcludedProducts,
    IF(RAND() > 0.6, 
        ELT(FLOOR(RAND() * 5) + 1, 'New', 'Silver', 'Gold', 'Platinum', 'All'),
        NULL
    ) AS TargetCustomerSegment
FROM 
    temp_promo_types pt
CROSS JOIN 
    (SELECT 1 AS num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) AS nums
ORDER BY 
    RAND()
LIMIT 120;

-- -----------------------------------------------------
-- Populate shopping_cart table (300+ rows) and shopping_cart_items
-- -----------------------------------------------------

-- Create shopping carts for about 15% of customers
INSERT INTO shopping_cart (CustomerID)
SELECT 
    CustomerID
FROM 
    customers
ORDER BY 
    RAND()
LIMIT 300;

-- Drop temporary tables
DROP TEMPORARY TABLE IF EXISTS temp_first_names;
DROP TEMPORARY TABLE IF EXISTS temp_last_names;
DROP TEMPORARY TABLE IF EXISTS temp_email_domains;
DROP TEMPORARY TABLE IF EXISTS temp_streets;
DROP TEMPORARY TABLE IF EXISTS temp_cities;
DROP TEMPORARY TABLE IF EXISTS temp_product_types;
DROP TEMPORARY TABLE IF EXISTS temp_product_features;
DROP TEMPORARY TABLE IF EXISTS temp_product_adjectives;
DROP TEMPORARY TABLE IF EXISTS temp_product_brands;
DROP TEMPORARY TABLE IF EXISTS temp_seasons;
DROP TEMPORARY TABLE IF EXISTS temp_promo_types;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Commit transaction to save data
COMMIT;

-- End of 03_dependent_tables.sql
-- Next file to be executed: 04_child_tables.sql
