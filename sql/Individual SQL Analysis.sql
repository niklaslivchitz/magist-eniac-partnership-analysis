
-- Looking up the categories to figure out how many are tech - probably must be counted by hand
SELECT * FROM product_category_name_translation ORDER BY product_category_name_english;
-- 'air_conditioning', 'audio', 'computers', 'computers_accessories', 'consoles_games', 'dvds_blu_ray', 'electronics', 'fixed_telephony', 'home_appliances', 'home_appliances_2', 'pc_gamer', 'portable_kitchen_food_processors', 'signaling_and_security', 'small_appliances', 'small_appliances_home_oven_and_coffee', 'tablets_printing_image', 'telephony'
-- How many in these categories have been sold?
SELECT 
    product_category_name_translation.product_category_name_english AS cat,
    COUNT(order_items.product_id) AS item_count
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_translation.product_category_name_english IN (
    'computers_accessories',
    'computers',
    'electronics',
    'telephony',
    'fixed_telephony',
    'tablets_printing_image',
    'audio',
    'cine_photo',
    'consoles_games'
)
GROUP BY cat
ORDER BY item_count DESC;

-- AS Percentage we need a count

SELECT 
    COUNT(*) AS total_items,
    SUM(CASE 
            WHEN product_category_name_translation.product_category_name_english IN (
                'computers_accessories','computers','electronics','telephony',
                'fixed_telephony','tablets_printing_image','audio',
                'cine_photo','consoles_games'
            ) THEN 1 ELSE 0 
        END) AS tech_items,
        product_category_name_translation.product_category_name_english
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY
	products.product_category_name;

-- average price of stuff being sold
SELECT ROUND(AVG(price))
FROM order_items;
-- AMONG TECH
SELECT AVG(CASE 
            WHEN product_category_name_translation.product_category_name_english IN (
                'computers_accessories','computers','electronics','telephony',
                'fixed_telephony','tablets_printing_image','audio',
                'cine_photo','consoles_games'
            ) THEN order_items.price
            ELSE NULL 
        END) AS tech_items_avg_price
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name;

-- are expensive tech products popular?
-- lets first check tech prices
SELECT order_items.price AS tech_items_price
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_translation.product_category_name_english IN (
    'computers_accessories','computers','electronics','telephony',
    'fixed_telephony','tablets_printing_image','audio',
    'cine_photo','consoles_games'
)
ORDER BY tech_items_price;

-- ok we can play with averages - i.e. how many items sold are above average price:

SELECT 
    COUNT(*) AS total_items,
    SUM(CASE 
            WHEN product_category_name_translation.product_category_name_english IN (
                'computers_accessories','computers','electronics','telephony',
                'fixed_telephony','tablets_printing_image','audio',
                'cine_photo','consoles_games'
            )
            AND order_items.price >= (
                SELECT AVG(order_items.price)
                FROM order_items
                LEFT JOIN products 
                    ON order_items.product_id = products.product_id
                LEFT JOIN product_category_name_translation 
                    ON products.product_category_name = product_category_name_translation.product_category_name
                WHERE product_category_name_translation.product_category_name_english IN (
                    'computers_accessories','computers','electronics','telephony',
                    'fixed_telephony','tablets_printing_image','audio',
                    'cine_photo','consoles_games'
                )
            )
            THEN 1 ELSE 0 
        END) AS tech_items_above_avg
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name;
    
-- or this?

SELECT 
    products.product_id,
    product_category_name_translation.product_category_name_english AS cat,
    order_items.price,
    COUNT(*) AS times_ordered
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_translation.product_category_name_english IN (
    'computers_accessories','computers','electronics','telephony',
    'fixed_telephony','tablets_printing_image','audio',
    'cine_photo','consoles_games'
)
GROUP BY products.product_id, cat, order_items.price
ORDER BY times_ordered DESC;

-- How many months of data are included in the snapshot?

SELECT
		order_purchase_timestamp
	FROM orders 
    ORDER BY 
		order_purchase_timestamp DESC;

-- HOw many sellers are there? How many tech seller? WHat percentage of sellers are tech sellers?
SELECT
	count(seller_id)
FROM sellers;
    
-- How many of them are tech sellers

SELECT
	count(DISTINCT order_items.seller_id)
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_translation.product_category_name_english IN (
    'computers_accessories','computers','electronics','telephony',
    'fixed_telephony','tablets_printing_image','audio',
    'cine_photo','consoles_games');

-- what are the total earnings per seller?

SELECT 
    SUM(order_items.price) AS total_revenue_all,
    SUM(CASE 
            WHEN product_category_name_translation.product_category_name_english IN (
                'computers_accessories','computers','electronics','telephony',
                'fixed_telephony','tablets_printing_image','audio',
                'cine_photo','consoles_games'
            ) THEN order_items.price ELSE 0 
        END) AS total_revenue_tech
FROM order_items
LEFT JOIN products 
    ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name;
    
-- average monthly income per normal/tech
-- monthly average income
SELECT
    ROUND(AVG(oi.price), 2) AS total_amount, 
    MONTH(o.order_purchase_timestamp) AS months, 
    YEAR(o.order_purchase_timestamp) AS years
FROM order_items oi
JOIN orders o
	ON oi.order_id = o.order_id
GROUP BY MONTH(o.order_purchase_timestamp), YEAR(o.order_purchase_timestamp)
ORDER BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp);


-- monthly average income of tech sellers
SELECT 
    ROUND(AVG(order_items.price), 2) AS average_price,
    MONTH(orders.order_purchase_timestamp) AS months,
    YEAR(orders.order_purchase_timestamp) AS years
FROM order_items
JOIN orders ON order_items.order_id = orders.order_id
JOIN products ON order_items.product_id = products.product_id
JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_translation.product_category_name_english IN (
    'audio', 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 
    'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony'
)
GROUP BY YEAR(orders.order_purchase_timestamp), MONTH(orders.order_purchase_timestamp)
ORDER BY YEAR(orders.order_purchase_timestamp), MONTH(orders.order_purchase_timestamp);

