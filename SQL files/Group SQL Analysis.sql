USE magist;

-- -------------------------------- 
-- Q2.1.1: What categories of tech products does Magist have?
-- SELECT * FROM product_category_name_translation  ORDER BY product_category_name_english ASC;  -- 74 total categories
-- SELECT COUNT(*) FROM product_category_name_translation;

SELECT COUNT(*)
FROM product_category_name_translation
WHERE product_category_name_english IN ('audio', 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image','telephony');
-- 10 categories


-- -------------------------------- 
-- Q2.1.2: How many products of these tech categories have been sold 
SELECT COUNT(*) AS total_products_sold
FROM order_items;
-- total_products_sold 112650

SELECT 
    COUNT(*) AS total_tech_products_sold, product_category_name_english
FROM
    order_items AS oi
	JOIN
    products AS p ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS pcnt
    ON p.product_category_name=pcnt.product_category_name
WHERE
    product_category_name_english IN ('audio', 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image','telephony')
        GROUP BY product_category_name_english
        ORDER BY COUNT(*) DESC;

    
 SELECT 
    total_products_sold,
    total_tech_products_sold,
    ROUND(100.0 * total_tech_products_sold / total_products_sold,2) AS tech_percentage
FROM
    (SELECT 
        COUNT(*) AS total_products_sold,
            COUNT(CASE
                WHEN pcnt.product_category_name_english IN ('audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony') THEN 1
            END) AS total_tech_products_sold
    FROM
        order_items AS oi
    JOIN products AS p ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS pcnt ON p.product_category_name = pcnt.product_category_name) AS totals;
    -- 15.33 percentage


-- -------------------------------- 
-- Q2.1.3 What’s the average price of the products being sold?
SELECT ROUND(AVG(price),2) average_price FROM order_items; -- 120.65


-- -------------------------------- 
-- Q2.1.4 Are expensive tech products popular?
SELECT *, 
CASE WHEN price > (SELECT ROUND(AVG(price),2) FROM order_items) THEN 'expensive'
ELSE 'cheap'
END as price_category
 FROM order_items;
 -- price_category

SELECT *,
CASE WHEN product_category_name_english IN ('audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony')
THEN 'tech'
ELSE 'non-tech'
END AS product_type

FROM product_category_name_translation;
-- product_type

SELECT price_category, product_type, COUNT(*) AS products_sold
FROM (SELECT oi.price,
	CASE WHEN oi.price > (SELECT AVG(price) FROM order_items)
	THEN 'expensive'
	ELSE 'cheap'
	END AS price_category,

	CASE WHEN pcnt.product_category_name_english IN ('audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony')
	THEN 'tech'
	ELSE 'non-tech'
	END AS product_type

    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pcnt
        ON p.product_category_name = pcnt.product_category_name
) AS products -- new table name --> products
GROUP BY
    price_category,
    product_type; 
    



-- -----------
-- Q2.2.1. How many months of data are included in the magist database?
SELECT 
    MIN(order_purchase_timestamp) AS min_month,
    MAX(order_purchase_timestamp) AS max_month,
    TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS months_of_data
FROM orders;
-- 25 months


-- -----------
-- Q2.2.2. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
SELECT COUNT(DISTINCT seller_id) FROM sellers; -- 3095 sellers

WITH new_data AS (SELECT s.seller_id,
        CASE
            WHEN pcnt.product_category_name_english IN ( 'audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony')
            THEN 'tech'
            ELSE 'non-tech'
        END AS product_type

    FROM sellers s
    JOIN order_items oi
		ON s.seller_id=oi.seller_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pcnt
        ON p.product_category_name = pcnt.product_category_name
)

SELECT COUNT(DISTINCT seller_id) tech_seller_num
FROM new_data
WHERE product_type='tech';
-- 493 tech sellers

WITH new_data AS (SELECT s.seller_id,
        CASE
            WHEN pcnt.product_category_name_english IN ('audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony')
            THEN 'tech'
            ELSE 'non-tech'
        END AS product_type

    FROM sellers s
    JOIN order_items oi ON s.seller_id=oi.seller_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
)

SELECT ROUND((COUNT(DISTINCT seller_id)*100)/(SELECT COUNT(DISTINCT seller_id) FROM sellers)) tech_seller_percent
FROM new_data
WHERE product_type='tech';
-- 16 percent


-- -----------
-- Q2.2.3. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT ROUND(SUM(price),2)  total_amount FROM order_items; -- 13591643.7

SELECT
    SUM(oi.price) AS total_amount_earned,
    SUM(CASE
            WHEN pcnt.product_category_name_english IN ('audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony')
            THEN oi.price -- If the product is tech, get the price.
            ELSE 0
        END) AS total_tech_amount_earned

FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pcnt
    ON p.product_category_name = pcnt.product_category_name;


-- -----------
-- Q2.2.4. Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
-- monthly average income
SELECT 
    ROUND(AVG(oi.price), 2) total_amount, MONTH(o.order_purchase_timestamp) months, YEAR(o.order_purchase_timestamp) years
FROM order_items oi
JOIN orders o
	ON oi.order_id=o.order_id
GROUP BY MONTH(o.order_purchase_timestamp), YEAR(o.order_purchase_timestamp)
ORDER BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp);


-- monthly average income of tech sellers
SELECT 
    ROUND(AVG(oi.price), 2) AS average_price,
    MONTH(o.order_purchase_timestamp) months,
    YEAR(o.order_purchase_timestamp) years
    
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pcnt
    ON p.product_category_name = pcnt.product_category_name

WHERE pcnt.product_category_name_english IN ('audio' , 'cine_photo', 'computers', 'computers_accessories', 'consoles_games', 'electronics', 'fixed_telephony', 'pc_gamer', 'tablets_printing_image', 'telephony')
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp);




-- -----------
-- Q2.3.1. What’s the average time between the order being placed and the product being delivered?
-- SELECT order_purchase_timestamp, order_delivered_customer_date FROM orders;
-- SELECT TIMESTAMPDIFF(HOUR, order_purchase_timestamp, order_delivered_customer_date) average_time FROM orders;

SELECT AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp, order_delivered_customer_date)) average_time FROM orders;



-- -----------
-- Q2.3.2. How many orders are delivered on time vs orders delivered with a delay?
SELECT CASE
       WHEN order_delivered_customer_date <= order_estimated_delivery_date
		THEN 'on time'
        ELSE 'delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL AND order_status = 'delivered'-- Only include orders that have actually been delivered
GROUP BY delivery_status;


-- -----------
-- Q2.3.3. Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
		THEN 'on time'
        ELSE 'delayed'
    END AS delivery_status,

    ROUND(AVG(p.product_weight_g), 2) AS avg_product_weight,
    COUNT(*) AS order_count

FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'AND o.order_delivered_customer_date IS NOT NULL

GROUP BY delivery_status;