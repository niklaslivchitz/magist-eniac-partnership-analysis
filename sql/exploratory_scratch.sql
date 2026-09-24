# USE magist;
# SELECT COUNT(*) FROM orders;
# SELECT order_status, COUNT(*) FROM orders GROUP BY order_status;
SELECT
		YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), COUNT(customer_id)
	FROM orders 
    GROUP BY year(order_purchase_timestamp), month(order_purchase_timestamp) 
    ORDER BY 
		year(order_purchase_timestamp) DESC, month(order_purchase_timestamp) DESC;
SELECT COUNT(DISTINCT product_id) from products;
SELECT product_category_name, COUNT(DISTINCT product_id) from products GROUP BY product_category_name ORDER BY COUNT(DISTINCT product_id) DESC;
SELECT count(DISTINCT product_id) from order_items;
SELECT MAX(price), MIN(price) FROM order_items;
SELECT MAX(payment_value), MIN(payment_value) FROM order_payments;
SELECT ROUND(SUM(payment_value)) FROM order_payments GROUP BY order_id ORDER BY SUM(payment_value) DESC;
