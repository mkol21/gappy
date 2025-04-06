-- GAP Retail Database - Data Population Script
-- 02_base_tables.sql - Populating Base Independent Tables
-- This script populates tables that have no foreign key dependencies
use gapdbase;
-- Enable safe mode for testing
SET SQL_SAFE_UPDATES = 0;

-- Start transaction for safer data loading
START TRANSACTION;

INSERT INTO payment_methods (MethodName, ProcessingFee, PaymentGateway)
VALUES
('Credit Card', 2.9, 'Stripe'),
('Debit Card', 1.5, 'Stripe'),
('PayPal', 2.5, 'PayPal'),
('Gift Card', 0.0, 'Internal'),
('Store Credit', 0.0, 'Internal');

-- Insert default payment statuses
INSERT INTO payment_status (StatusName, StatusDescription)
VALUES
('Pending', 'Payment is being processed'),
('Authorized', 'Payment has been authorized but not captured'),
('Captured', 'Payment has been captured'),
('Failed', 'Payment processing failed'),
('Refunded', 'Payment has been refunded'),
('Partially Refunded', 'Payment has been partially refunded');

-- Populate initial categories
INSERT INTO categories (CategoryName, CategoryDescription, ParentCategoryID)
VALUES
('Men', 'Men\'s clothing and accessories', NULL),
('Women', 'Women\'s clothing and accessories', NULL),
('Kids', 'Children\'s clothing and accessories', NULL),
('Baby', 'Infant clothing and accessories', NULL),
('Accessories', 'Fashion accessories for all', NULL);

-- Add subcategories (after parent categories exist)
INSERT INTO categories (CategoryName, CategoryDescription, ParentCategoryID)
VALUES
('T-Shirts', 'Men\'s t-shirts and tops', 1),
('Jeans', 'Men\'s jeans and denim', 1),
('Dresses', 'Women\'s dresses', 2),
('Tops', 'Women\'s tops and blouses', 2),
('Boys', 'Boys\' clothing', 3),
('Girls', 'Girls\' clothing', 3);

-- -----------------------------------------------------
-- Populate additional categories (total 50+)
-- -----------------------------------------------------
INSERT INTO categories (CategoryName, CategoryDescription, ParentCategoryID) VALUES
-- Men's subcategories (parent 1)
('Shirts', 'Men\'s button-down and casual shirts', 1),
('Pants', 'Men\'s pants and trousers', 1),
('Sweaters', 'Men\'s sweaters and cardigans', 1),
('Jackets & Coats', 'Men\'s outerwear', 1),
('Activewear', 'Men\'s athletic and workout apparel', 1),
('Suits', 'Men\'s formal wear and suits', 1),
('Shorts', 'Men\'s shorts', 1),
('Underwear', 'Men\'s underwear and boxers', 1),
('Sleepwear', 'Men\'s pajamas and loungewear', 1),
('Swimwear', 'Men\'s swim trunks and board shorts', 1),
('Socks', 'Men\'s socks and hosiery', 1),

-- Women's subcategories (parent 2)
('Blouses', 'Women\'s blouses and dressy tops', 2),
('Sweaters & Cardigans', 'Women\'s knitwear', 2),
('Pants & Leggings', 'Women\'s pants and leggings', 2),
('Jeans', 'Women\'s jeans and denim', 2),
('Skirts', 'Women\'s skirts', 2),
('Jackets & Coats', 'Women\'s outerwear', 2),
('Activewear', 'Women\'s athletic and workout apparel', 2),
('Sleepwear', 'Women\'s pajamas and loungewear', 2),
('Intimates', 'Women\'s underwear and lingerie', 2),
('Swimwear', 'Women\'s swimsuits and cover-ups', 2),
('Maternity', 'Maternity clothing', 2),
('Shorts', 'Women\'s shorts', 2),

-- Kids subcategories (parent 3)
('Shirts & Tops', 'Kids\' shirts and tops', 3),
('Pants & Jeans', 'Kids\' pants and jeans', 3),
('Outerwear', 'Kids\' jackets and coats', 3),
('Activewear', 'Kids\' athletic apparel', 3),
('Swimwear', 'Kids\' swim apparel', 3),
('Sleepwear', 'Kids\' pajamas', 3),
('Underwear', 'Kids\' underwear', 3),
('School Uniforms', 'School uniform essentials', 3),

-- Baby subcategories (parent 4)
('Bodysuits & Rompers', 'Baby one-pieces', 4),
('Tops & Bottoms', 'Baby separates', 4),
('Sets & Outfits', 'Coordinated baby outfits', 4),
('Sleepwear', 'Baby pajamas and sleep sacks', 4),
('Outerwear', 'Baby jackets and outerwear', 4),
('Swimwear', 'Baby swim apparel', 4),

-- Accessories subcategories (parent 5)
('Bags & Purses', 'Handbags, totes, and backpacks', 5),
('Jewelry', 'Fashion jewelry', 5),
('Hats & Caps', 'Headwear', 5),
('Belts', 'Fashion belts', 5),
('Scarves & Wraps', 'Neck accessories', 5),
('Sunglasses', 'Fashion eyewear', 5),
('Watches', 'Wristwatches', 5),
('Hair Accessories', 'Hair bands, clips, and more', 5),
('Tech Accessories', 'Phone cases and tech accessories', 5);

-- -----------------------------------------------------
-- Populate warehouses (50 rows)
-- -----------------------------------------------------
INSERT INTO warehouses (WarehouseName, WarehouseLocation, WarehouseCapacity, ContactPhone, ContactEmail, OperatingHours) VALUES
-- East Coast Warehouses
('East Regional DC', 'Secaucus, NJ', 1250000, '201-555-1000', 'east.dc@gap.com', 'Mon-Fri: 6am-10pm, Sat: 8am-6pm'),
('Northeast Fulfillment Center', 'Philadelphia, PA', 980000, '215-555-1001', 'philly.dc@gap.com', 'Mon-Sun: 24 hours'),
('Southeast DC', 'Atlanta, GA', 1100000, '404-555-1002', 'atlanta.dc@gap.com', 'Mon-Sun: 24 hours'),
('Mid-Atlantic Distribution', 'Richmond, VA', 720000, '804-555-1003', 'richmond.dc@gap.com', 'Mon-Fri: 7am-9pm, Sat: 8am-5pm'),
('Florida Fulfillment Center', 'Jacksonville, FL', 850000, '904-555-1004', 'jax.dc@gap.com', 'Mon-Sat: 7am-11pm'),
('New England Distribution', 'Boston, MA', 560000, '617-555-1005', 'boston.dc@gap.com', 'Mon-Fri: 6am-8pm'),
('NYC Metro Center', 'Edison, NJ', 500000, '732-555-1006', 'edison.dc@gap.com', 'Mon-Fri: 24 hours, Sat: 8am-8pm'),
('North Carolina DC', 'Charlotte, NC', 670000, '704-555-1007', 'charlotte.dc@gap.com', 'Mon-Sat: 7am-9pm'),
('South Florida DC', 'Miami, FL', 480000, '305-555-1008', 'miami.dc@gap.com', 'Mon-Fri: 7am-8pm'),
('Tennessee Distribution Center', 'Nashville, TN', 590000, '615-555-1009', 'nashville.dc@gap.com', 'Mon-Fri: 6am-9pm'),

-- Central Region Warehouses
('Central Regional DC', 'Columbus, OH', 1300000, '614-555-1100', 'columbus.dc@gap.com', 'Mon-Sun: 24 hours'),
('Midwest Fulfillment Center', 'Chicago, IL', 1050000, '312-555-1101', 'chicago.dc@gap.com', 'Mon-Sun: 24 hours'),
('Texas Primary DC', 'Dallas, TX', 1200000, '214-555-1102', 'dallas.dc@gap.com', 'Mon-Sun: 24 hours'),
('Texas Secondary DC', 'Houston, TX', 850000, '713-555-1103', 'houston.dc@gap.com', 'Mon-Sat: 6am-10pm'),
('Minnesota Distribution Center', 'Minneapolis, MN', 670000, '612-555-1104', 'minneapolis.dc@gap.com', 'Mon-Fri: 7am-9pm'),
('Michigan DC', 'Detroit, MI', 580000, '313-555-1105', 'detroit.dc@gap.com', 'Mon-Fri: 6am-8pm'),
('Missouri Fulfillment Center', 'St. Louis, MO', 620000, '314-555-1106', 'stlouis.dc@gap.com', 'Mon-Sat: 7am-9pm'),
('Colorado Distribution', 'Denver, CO', 530000, '303-555-1107', 'denver.dc@gap.com', 'Mon-Fri: 7am-8pm'),
('Indiana Warehouse', 'Indianapolis, IN', 470000, '317-555-1108', 'indy.dc@gap.com', 'Mon-Fri: 6am-8pm'),
('Wisconsin DC', 'Milwaukee, WI', 410000, '414-555-1109', 'milwaukee.dc@gap.com', 'Mon-Fri: 7am-7pm'),

-- West Coast Warehouses
('West Regional DC', 'Fresno, CA', 1400000, '559-555-1200', 'fresno.dc@gap.com', 'Mon-Sun: 24 hours'),
('Pacific Northwest DC', 'Seattle, WA', 890000, '206-555-1201', 'seattle.dc@gap.com', 'Mon-Sun: 6am-10pm'),
('SoCal Distribution Center', 'Riverside, CA', 1100000, '951-555-1202', 'riverside.dc@gap.com', 'Mon-Sun: 24 hours'),
('Bay Area Fulfillment', 'Oakland, CA', 750000, '510-555-1203', 'oakland.dc@gap.com', 'Mon-Sat: 6am-9pm'),
('Arizona Distribution', 'Phoenix, AZ', 680000, '602-555-1204', 'phoenix.dc@gap.com', 'Mon-Sat: 5am-9pm'),
('Oregon Warehouse', 'Portland, OR', 510000, '503-555-1205', 'portland.dc@gap.com', 'Mon-Fri: 6am-8pm'),
('Nevada Fulfillment Center', 'Reno, NV', 630000, '775-555-1206', 'reno.dc@gap.com', 'Mon-Sat: 6am-8pm'),
('San Diego DC', 'San Diego, CA', 490000, '619-555-1207', 'sandiego.dc@gap.com', 'Mon-Fri: 6am-8pm'),
('Utah Distribution', 'Salt Lake City, UT', 520000, '801-555-1208', 'slc.dc@gap.com', 'Mon-Fri: 7am-9pm'),
('Hawaii Distribution', 'Honolulu, HI', 280000, '808-555-1209', 'honolulu.dc@gap.com', 'Mon-Fri: 7am-7pm'),

-- International Warehouses
('Canada Main DC', 'Toronto, ON, Canada', 950000, '+1-416-555-1300', 'toronto.dc@gap.com', 'Mon-Fri: 7am-9pm'),
('Canada West DC', 'Vancouver, BC, Canada', 580000, '+1-604-555-1301', 'vancouver.dc@gap.com', 'Mon-Fri: 7am-7pm'),
('UK Distribution Center', 'Milton Keynes, UK', 870000, '+44-1908-555-1302', 'uk.dc@gap.com', 'Mon-Fri: 8am-8pm'),
('European Main DC', 'Amsterdam, Netherlands', 920000, '+31-20-555-1303', 'europe.dc@gap.com', 'Mon-Fri: 8am-8pm'),
('France Distribution', 'Paris, France', 610000, '+33-1-5555-1304', 'france.dc@gap.com', 'Mon-Fri: 9am-7pm'),
('Germany Fulfillment', 'Frankfurt, Germany', 680000, '+49-69-5555-1305', 'germany.dc@gap.com', 'Mon-Fri: 8am-8pm'),
('Italy Warehouse', 'Milan, Italy', 540000, '+39-02-5555-1306', 'italy.dc@gap.com', 'Mon-Fri: 9am-7pm'),
('Spain Distribution', 'Madrid, Spain', 520000, '+34-91-5555-1307', 'spain.dc@gap.com', 'Mon-Fri: 9am-7pm'),
('Japan Main DC', 'Tokyo, Japan', 630000, '+81-3-5555-1308', 'japan.dc@gap.com', 'Mon-Fri: 9am-7pm'),
('China Distribution', 'Shanghai, China', 780000, '+86-21-5555-1309', 'china.dc@gap.com', 'Mon-Fri: 9am-7pm'),

-- Specialty Warehouses
('E-Commerce Fulfillment East', 'Allentown, PA', 1050000, '484-555-1400', 'ecom.east@gap.com', 'Mon-Sun: 24 hours'),
('E-Commerce Fulfillment West', 'Stockton, CA', 980000, '209-555-1401', 'ecom.west@gap.com', 'Mon-Sun: 24 hours'),
('Outlet Merchandise DC', 'Lancaster, PA', 640000, '717-555-1402', 'outlet.dc@gap.com', 'Mon-Fri: 7am-7pm'),
('Seasonal Storage East', 'Baltimore, MD', 580000, '410-555-1403', 'seasonal.east@gap.com', 'Mon-Fri: 8am-6pm'),
('Seasonal Storage West', 'Rialto, CA', 540000, '909-555-1404', 'seasonal.west@gap.com', 'Mon-Fri: 8am-6pm'),
('Returns Processing Center', 'Columbus, OH', 490000, '614-555-1405', 'returns.processing@gap.com', 'Mon-Sat: 7am-9pm'),
('Archive & Special Items', 'Burbank, CA', 320000, '818-555-1406', 'archive.storage@gap.com', 'Mon-Fri: 9am-5pm'),
('Flagship Store Support', 'New York, NY', 290000, '212-555-1407', 'flagship.support@gap.com', 'Mon-Fri: 8am-8pm'),
('International Shipping Hub', 'Miami, FL', 420000, '305-555-1408', 'intl.shipping@gap.com', 'Mon-Fri: 24 hours'),
('Specialty Brands DC', 'Fishkill, NY', 670000, '845-555-1409', 'specialty.dc@gap.com', 'Mon-Fri: 7am-7pm');

-- -----------------------------------------------------
-- Populate stores (100 rows)
-- -----------------------------------------------------
-- Create 5 regions for store organization
INSERT INTO stores (StoreName, Location, StorePhone, StoreEmail, ManagerName, OperatingHours, StoreSize, RegionID) VALUES
-- Northeast Region (RegionID 1)
('GAP New York - Fifth Ave', '680 5th Ave, New York, NY 10019', '212-555-2000', 'nyc.5ave@gap.com', 'Sarah Johnson', 'Mon-Sat: 10am-8pm, Sun: 11am-7pm', 12500, 1),
('GAP Boston - Newbury', '140 Newbury St, Boston, MA 02116', '617-555-2001', 'boston.newbury@gap.com', 'Michael Chen', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 8700, 1),
('GAP Philadelphia - Walnut', '1510 Walnut St, Philadelphia, PA 19102', '215-555-2002', 'philly.walnut@gap.com', 'Jessica Williams', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 9200, 1),
('GAP Brooklyn - Atlantic Center', '625 Atlantic Ave, Brooklyn, NY 11217', '718-555-2003', 'brooklyn.atlantic@gap.com', 'David Singh', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 10500, 1),
('GAP White Plains - The Westchester', '125 Westchester Ave, White Plains, NY 10601', '914-555-2004', 'whiteplainswest@gap.com', 'Lauren Miller', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7800, 1),
('GAP Providence Place', '1 Providence Place, Providence, RI 02903', '401-555-2005', 'providence.place@gap.com', 'Robert Davis', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 8100, 1),
('GAP Albany - Crossgates Mall', '1 Crossgates Mall Rd, Albany, NY 12203', '518-555-2006', 'albany.crossgates@gap.com', 'Emily Wilson', 'Mon-Sat: 10am-9:30pm, Sun: 11am-6pm', 7200, 1),
('GAP Hartford - Westfarms', '500 Westfarms Mall, Farmington, CT 06032', '860-555-2007', 'hartford.westfarms@gap.com', 'Daniel Martinez', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7500, 1),
('GAP Burlington Mall', '75 Middlesex Turnpike, Burlington, MA 01803', '781-555-2008', 'burlington.mall@gap.com', 'Jennifer Lopez', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7800, 1),
('GAP Syracuse - Destiny USA', '9090 Destiny USA Dr, Syracuse, NY 13204', '315-555-2009', 'syracuse.destiny@gap.com', 'Anthony Brown', 'Mon-Sat: 10am-9:30pm, Sun: 11am-6pm', 8400, 1),
('GAP Buffalo - Walden Galleria', '1 Walden Galleria, Buffalo, NY 14225', '716-555-2010', 'buffalo.walden@gap.com', 'Samantha Lee', 'Mon-Sat: 10am-9:30pm, Sun: 11am-6pm', 7300, 1),
('GAP Portland - Maine Mall', '364 Maine Mall Rd, South Portland, ME 04106', '207-555-2011', 'portland.maine@gap.com', 'Thomas Wilson', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 6900, 1),
('GAP Manchester - Mall of New Hampshire', '1500 S Willow St, Manchester, NH 03103', '603-555-2012', 'manchester.nh@gap.com', 'Amanda Garcia', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 6800, 1),
('GAP Pittsburgh - Ross Park Mall', '1000 Ross Park Mall Dr, Pittsburgh, PA 15237', '412-555-2013', 'pittsburgh.ross@gap.com', 'Brandon Clark', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7700, 1),
('GAP Buffalo - Fashion Outlets', '1900 Military Rd, Niagara Falls, NY 14304', '716-555-2014', 'niagara.outlets@gap.com', 'Nicole Adams', 'Mon-Sat: 10am-9pm, Sun: 10am-6pm', 5500, 1),
('GAP Atlantic City - Tanger Outlets', '2014 Baltic Ave, Atlantic City, NJ 08401', '609-555-2015', 'ac.tanger@gap.com', 'Kevin Wright', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 5800, 1),
('GAP Princeton MarketFair', '3535 US Highway 1, Princeton, NJ 08540', '609-555-2016', 'princeton.market@gap.com', 'Maria Hernandez', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7400, 1),
('GAP Paramus Park', '700 Paramus Park, Paramus, NJ 07652', '201-555-2017', 'paramus.park@gap.com', 'Jason Taylor', 'Mon-Sat: 10am-9:30pm, Sun: 11am-7pm', 7900, 1),
('GAP Freehold Raceway Mall', '3710 US Hwy 9, Freehold, NJ 07728', '732-555-2018', 'freehold.raceway@gap.com', 'Stephanie Green', 'Mon-Sat: 10am-9:30pm, Sun: 11am-7pm', 7600, 1),
('GAP Newark - The Mills at Jersey Gardens', '651 Kapkowski Rd, Elizabeth, NJ 07201', '908-555-2019', 'jersey.gardens@gap.com', 'Christopher Ross', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 8100, 1),

-- Southeast Region (RegionID 2)
('GAP Atlanta - Lenox Square', '3393 Peachtree Rd NE, Atlanta, GA 30326', '404-555-2100', 'atlanta.lenox@gap.com', 'Melissa Johnson', 'Mon-Sat: 10am-9pm, Sun: 12pm-7pm', 9800, 2),
('GAP Miami - Dadeland Mall', '7535 N Kendall Dr, Miami, FL 33156', '305-555-2101', 'miami.dadeland@gap.com', 'Carlos Rodriguez', 'Mon-Sat: 10am-9:30pm, Sun: 11am-7pm', 8900, 2),
('GAP Orlando - Florida Mall', '8001 S Orange Blossom Trl, Orlando, FL 32809', '407-555-2102', 'orlando.florida@gap.com', 'Sophia Martinez', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 8400, 2),
('GAP Charlotte - SouthPark', '4400 Sharon Rd, Charlotte, NC 28211', '704-555-2103', 'charlotte.southpark@gap.com', 'William Davis', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 8300, 2),
('GAP Nashville - The Mall at Green Hills', '2126 Abbott Martin Rd, Nashville, TN 37215', '615-555-2104', 'nashville.greenhills@gap.com', 'Emma Wilson', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7800, 2),
('GAP Tampa - International Plaza', '2223 N Westshore Blvd, Tampa, FL 33607', '813-555-2105', 'tampa.plaza@gap.com', 'Alexander Brown', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 8100, 2),
('GAP Raleigh - Crabtree Valley Mall', '4325 Glenwood Ave, Raleigh, NC 27612', '919-555-2106', 'raleigh.crabtree@gap.com', 'Olivia Moore', 'Mon-Sat: 10am-9pm, Sun: 12pm-7pm', 7600, 2),
('GAP Birmingham - The Summit', '214 Summit Blvd, Birmingham, AL 35243', '205-555-2107', 'birmingham.summit@gap.com', 'Ethan Thompson', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7200, 2),
('GAP New Orleans - Lakeside Shopping Center', '3301 Veterans Memorial Blvd, Metairie, LA 70002', '504-555-2108', 'neworleans.lakeside@gap.com', 'Isabella Martin', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7500, 2),
('GAP Jacksonville - St. Johns Town Center', '4755 Town Crossing Dr, Jacksonville, FL 32246', '904-555-2109', 'jacksonville.stjohns@gap.com', 'Mason Garcia', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7800, 2),
('GAP Louisville - Oxmoor Center', '7900 Shelbyville Rd, Louisville, KY 40222', '502-555-2110', 'louisville.oxmoor@gap.com', 'Sofia Rodriguez', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7100, 2),
('GAP Charleston - Tanger Outlets', '4840 Tanger Outlet Blvd, North Charleston, SC 29418', '843-555-2111', 'charleston.tanger@gap.com', 'Jack Walker', 'Mon-Sat: 9am-9pm, Sun: 10am-7pm', 5600, 2),
('GAP Richmond - Short Pump Town Center', '11800 W Broad St, Richmond, VA 23233', '804-555-2112', 'richmond.shortpump@gap.com', 'Chloe White', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7700, 2),
('GAP Memphis - Wolfchase Galleria', '2760 N Germantown Pkwy, Memphis, TN 38133', '901-555-2113', 'memphis.wolfchase@gap.com', 'Benjamin Hill', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7300, 2),
('GAP West Palm Beach - The Gardens Mall', '3101 PGA Blvd, Palm Beach Gardens, FL 33410', '561-555-2114', 'wpb.gardens@gap.com', 'Mia Scott', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7900, 2),
('GAP Savannah - Oglethorpe Mall', '7804 Abercorn St, Savannah, GA 31406', '912-555-2115', 'savannah.oglethorpe@gap.com', 'Logan Baker', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 6800, 2),
('GAP Columbia - Columbiana Centre', '100 Columbiana Cir, Columbia, SC 29212', '803-555-2116', 'columbia.centre@gap.com', 'Zoe Nelson', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7200, 2),
('GAP Lexington - Fayette Mall', '3401 Nicholasville Rd, Lexington, KY 40503', '859-555-2117', 'lexington.fayette@gap.com', 'Ryan Phillips', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7100, 2),
('GAP Knoxville - West Town Mall', '7600 Kingston Pike, Knoxville, TN 37919', '865-555-2118', 'knoxville.westtown@gap.com', 'Hannah Cooper', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7400, 2),
('GAP Ft. Lauderdale - Sawgrass Mills', '12801 W Sunrise Blvd, Sunrise, FL 33323', '954-555-2119', 'ftlauderdale.sawgrass@gap.com', 'Caleb Reed', 'Mon-Sat: 10am-9:30pm, Sun: 11am-8pm', 8000, 2),

-- Midwest Region (RegionID 3)
('GAP Chicago - Michigan Avenue', '555 N Michigan Ave, Chicago, IL 60611', '312-555-2200', 'chicago.michigan@gap.com', 'Natalie Roberts', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 11000, 3),
('GAP Minneapolis - Mall of America', '60 E Broadway, Bloomington, MN 55425', '952-555-2201', 'minneapolis.moa@gap.com', 'Owen Campbell', 'Mon-Sat: 10am-9:30pm, Sun: 11am-7pm', 9500, 3),
('GAP Detroit - Somerset Collection', '2800 W Big Beaver Rd, Troy, MI 48084', '248-555-2202', 'detroit.somerset@gap.com', 'Lily Evans', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 8400, 3),
('GAP St. Louis - Saint Louis Galleria', '1155 Saint Louis Galleria, St. Louis, MO 63117', '314-555-2203', 'stlouis.galleria@gap.com', 'Gabriel Morgan', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7800, 3),
('GAP Indianapolis - Keystone Fashion Mall', '8702 Keystone Crossing, Indianapolis, IN 46240', '317-555-2204', 'indy.keystone@gap.com', 'Addison Parker', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7700, 3),
('GAP Columbus - Easton Town Center', '4044 The Strand, Columbus, OH 43219', '614-555-2205', 'columbus.easton@gap.com', 'Levi Stewart', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 8200, 3),
('GAP Kansas City - Country Club Plaza', '438 W 47th St, Kansas City, MO 64112', '816-555-2206', 'kc.countryclub@gap.com', 'Brooklyn Carter', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7300, 3),
('GAP Milwaukee - Mayfair Mall', '2500 N Mayfair Rd, Wauwatosa, WI 53226', '414-555-2207', 'milwaukee.mayfair@gap.com', 'Leo Mitchell', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7500, 3),
('GAP Cleveland - Beachwood Place', '26300 Cedar Rd, Beachwood, OH 44122', '216-555-2208', 'cleveland.beachwood@gap.com', 'Audrey Richardson', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7600, 3),
('GAP Des Moines - Jordan Creek Town Center', '101 Jordan Creek Pkwy, West Des Moines, IA 50266', '515-555-2209', 'desmoines.jordan@gap.com', 'Lincoln Hayes', 'Mon-Sat: 10am-9pm, Sun: 12pm-5:30pm', 7200, 3),
('GAP Omaha - Village Pointe', '17151 Davenport St, Omaha, NE 68118', '402-555-2210', 'omaha.village@gap.com', 'Scarlett Foster', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7100, 3),
('GAP Cincinnati - Kenwood Towne Centre', '7875 Montgomery Rd, Cincinnati, OH 45236', '513-555-2211', 'cincinnati.kenwood@gap.com', 'Hudson Allen', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7400, 3),
('GAP Grand Rapids - Woodland Mall', '3195 28th St SE, Grand Rapids, MI 49512', '616-555-2212', 'grandrapids.woodland@gap.com', 'Stella Watson', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7000, 3),
('GAP Oklahoma City - Penn Square Mall', '1901 Northwest Expy, Oklahoma City, OK 73118', '405-555-2213', 'okc.pennsquare@gap.com', 'Chase Russell', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7300, 3),
('GAP Madison - West Towne Mall', '66 West Towne Mall, Madison, WI 53719', '608-555-2214', 'madison.westtowne@gap.com', 'Willow Price', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 6900, 3),
('GAP Fargo - West Acres Shopping Center', '3902 13th Ave S, Fargo, ND 58103', '701-555-2215', 'fargo.westacres@gap.com', 'Sawyer Griffin', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 6500, 3),
('GAP Sioux Falls - The Empire Mall', '5000 Empire Mall, Sioux Falls, SD 57106', '605-555-2216', 'siouxfalls.empire@gap.com', 'Ruby Ward', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 6700, 3),
('GAP Chicago - Woodfield Mall', '5 Woodfield Mall, Schaumburg, IL 60173', '847-555-2217', 'chicago.woodfield@gap.com', 'Julian King', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 8100, 3),
('GAP Toledo - Franklin Park Mall', '5001 Monroe St, Toledo, OH 43623', '419-555-2218', 'toledo.franklin@gap.com', 'Autumn Torres', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 6800, 3),
('GAP Chicago Premium Outlets', '1650 Premium Outlet Blvd, Aurora, IL 60502', '630-555-2219', 'chicago.premoutlets@gap.com', 'Kai Sullivan', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 5900, 3),

-- Southwest Region (RegionID 4)
('GAP Dallas - NorthPark Center', '8687 N Central Expy, Dallas, TX 75225', '214-555-2300', 'dallas.northpark@gap.com', 'Violet Adams', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 9200, 4),
('GAP Houston - The Galleria', '5085 Westheimer Rd, Houston, TX 77056', '713-555-2301', 'houston.galleria@gap.com', 'Grayson Bennett', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 8800, 4),
('GAP Phoenix - Scottsdale Fashion Square', '7014 E Camelback Rd, Scottsdale, AZ 85251', '480-555-2302', 'phoenix.scottsdale@gap.com', 'Paisley Rogers', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 8300, 4),
('GAP Austin - The Domain', '11410 Century Oaks Terrace, Austin, TX 78758', '512-555-2303', 'austin.domain@gap.com', 'Nolan Perry', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 8100, 4),
('GAP San Antonio - North Star Mall', '7400 San Pedro Ave, San Antonio, TX 78216', '210-555-2304', 'sanantonio.northstar@gap.com', 'Aurora Brooks', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7800, 4),
('GAP Las Vegas - Fashion Show Mall', '3200 Las Vegas Blvd S, Las Vegas, NV 89109', '702-555-2305', 'lasvegas.fashionshow@gap.com', 'Xavier Howard', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 8500, 4),
('GAP Albuquerque - ABQ Uptown', '2240 Q St NE, Albuquerque, NM 87110', '505-555-2306', 'abq.uptown@gap.com', 'Ellie Kelly', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7200, 4),
('GAP Tucson - La Encantada', '2905 E Skyline Dr, Tucson, AZ 85718', '520-555-2307', 'tucson.encantada@gap.com', 'Harrison Coleman', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7400, 4),
('GAP El Paso - Cielo Vista Mall', '8401 Gateway Blvd W, El Paso, TX 79925', '915-555-2308', 'elpaso.cielovista@gap.com', 'Jade Butler', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7100, 4),
('GAP Fort Worth - The Shops at Clearfork', '5188 Monahans Ave, Fort Worth, TX 76109', '817-555-2309', 'fortworth.clearfork@gap.com', 'Wesley Simmons', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7700, 4),
('GAP Tulsa - Woodland Hills Mall', '7021 S Memorial Dr, Tulsa, OK 74133', '918-555-2310', 'tulsa.woodland@gap.com', 'Ivy Barnes', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7100, 4),
('GAP San Antonio - Shops at La Cantera', '15900 La Cantera Pkwy, San Antonio, TX 78256', '210-555-2311', 'sanantonio.cantera@gap.com', 'Axel Fisher', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7500, 4),
('GAP Phoenix - Desert Ridge Marketplace', '21001 N Tatum Blvd, Phoenix, AZ 85050', '480-555-2312', 'phoenix.desertridge@gap.com', 'Everly Ross', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7300, 4),
('GAP Lubbock - South Plains Mall', '6002 Slide Rd, Lubbock, TX 79414', '806-555-2313', 'lubbock.southplains@gap.com', 'Jaxon Henderson', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 6800, 4),
('GAP Albuquerque - Coronado Center', '6600 Menaul Blvd NE, Albuquerque, NM 87110', '505-555-2314', 'abq.coronado@gap.com', 'Nova Peterson', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7000, 4),
('GAP Round Rock Premium Outlets', '4401 N Interstate 35, Round Rock, TX 78664', '512-555-2315', 'roundrock.outlets@gap.com', 'Brett Collins', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 5800, 4),
('GAP Amarillo - Westgate Mall', '7701 W Interstate 40, Amarillo, TX 79121', '806-555-2316', 'amarillo.westgate@gap.com', 'Ember Powell', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 6600, 4),
('GAP Denver Premium Outlets', '13801 Grant St, Thornton, CO 80023', '303-555-2317', 'denver.premoutlets@gap.com', 'Drew Patterson', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 5700, 4),
('GAP Phoenix Premium Outlets', '4976 Premium Outlets Way, Chandler, AZ 85226', '480-555-2318', 'phoenix.premoutlets@gap.com', 'Joanna Morris', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 5900, 4),
('GAP Santa Fe - Fashion Outlets of Santa Fe', '8380 Cerrillos Rd, Santa Fe, NM 87507', '505-555-2319', 'santafe.fashionout@gap.com', 'Felix Crawford', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 5500, 4),

-- West Coast Region (RegionID 5)
('GAP San Francisco - Union Square', '890 Market St, San Francisco, CA 94102', '415-555-2400', 'sf.unionsquare@gap.com', 'Eliana Turner', 'Mon-Sat: 10am-8pm, Sun: 11am-7pm', 10500, 5),
('GAP Los Angeles - The Grove', '189 The Grove Dr, Los Angeles, CA 90036', '323-555-2401', 'la.grove@gap.com', 'Silas Holmes', 'Mon-Sat: 10am-9pm, Sun: 11am-8pm', 9800, 5),
('GAP Seattle - Westlake Center', '400 Pine St, Seattle, WA 98101', '206-555-2402', 'seattle.westlake@gap.com', 'London Cooper', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 8900, 5),
('GAP Portland - Pioneer Place', '700 SW 5th Ave, Portland, OR 97204', '503-555-2403', 'portland.pioneer@gap.com', 'Roman Jenkins', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 8200, 5),
('GAP San Diego - Fashion Valley', '7007 Friars Rd, San Diego, CA 92108', '619-555-2404', 'sandiego.valley@gap.com', 'Oakley Bryant', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 8400, 5),
('GAP Denver - Cherry Creek Shopping Center', '3000 E 1st Ave, Denver, CO 80206', '303-555-2405', 'denver.cherrycreek@gap.com', 'Juniper Griffin', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 8100, 5),
('GAP San Jose - Santana Row', '377 Santana Row, San Jose, CA 95128', '408-555-2406', 'sanjose.santana@gap.com', 'Callum Reed', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 7800, 5),
('GAP Sacramento - Arden Fair', '1689 Arden Way, Sacramento, CA 95815', '916-555-2407', 'sacramento.arden@gap.com', 'Margot Cox', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7600, 5),
('GAP Santa Monica Place', '395 Santa Monica Pl, Santa Monica, CA 90401', '310-555-2408', 'santamonica.place@gap.com', 'Zane Diaz', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 7700, 5),
('GAP Salt Lake City - City Creek Center', '50 S Main St, Salt Lake City, UT 84101', '801-555-2409', 'slc.citycreek@gap.com', 'Harlow Sanders', 'Mon-Sat: 10am-9pm, Sun: 12pm-6pm', 7800, 5),
('GAP Berkeley - Fourth Street', '1990 Fourth St, Berkeley, CA 94710', '510-555-2410', 'berkeley.fourth@gap.com', 'Nash Douglas', 'Mon-Sat: 10am-7pm, Sun: 11am-6pm', 6800, 5),
('GAP Portland - Washington Square', '9585 SW Washington Square Rd, Portland, OR 97223', '503-555-2411', 'portland.washsq@gap.com', 'Adelaide Gray', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7200, 5),
('GAP Bellevue Square', '575 Bellevue Square, Bellevue, WA 98004', '425-555-2412', 'bellevue.square@gap.com', 'Kaden Hamilton', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 7500, 5),
('GAP Irvine Spectrum Center', '71 Fortune Dr, Irvine, CA 92618', '949-555-2413', 'irvine.spectrum@gap.com', 'Pearl Freeman', 'Mon-Sat: 10am-9pm, Sun: 11am-7pm', 7400, 5),
('GAP Walnut Creek - Broadway Plaza', '1259 Broadway Plaza, Walnut Creek, CA 94596', '925-555-2414', 'walnutcreek.plaza@gap.com', 'Rhett Harrison', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 7100, 5),
('GAP San Francisco Premium Outlets', '8300 Arroyo Cir, Livermore, CA 94551', '925-555-2415', 'sf.premoutlets@gap.com', 'Dahlia Graham', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 6000, 5),
('GAP Boise - Boise Towne Square', '350 N Milwaukee St, Boise, ID 83704', '208-555-2416', 'boise.townesquare@gap.com', 'Otto Richards', 'Mon-Sat: 10am-9pm, Sun: 11am-6pm', 7000, 5),
('GAP Spokane - River Park Square', '808 W Main Ave, Spokane, WA 99201', '509-555-2417', 'spokane.riverpark@gap.com', 'Sunny Wallace', 'Mon-Sat: 10am-8pm, Sun: 11am-6pm', 6900, 5),
('GAP Seattle Premium Outlets', '10600 Quil Ceda Blvd, Tulalip, WA 98271', '360-555-2418', 'seattle.premoutlets@gap.com', 'Flynn Warren', 'Mon-Sat: 10am-9pm, Sun: 10am-7pm', 5600, 5),
('GAP Palm Desert - El Paseo', '73-585 El Paseo, Palm Desert, CA 92260', '760-555-2419', 'palmdesert.elpaseo@gap.com', 'Olive Fleming', 'Mon-Sat: 10am-7pm, Sun: 11am-5pm', 6700, 5);

