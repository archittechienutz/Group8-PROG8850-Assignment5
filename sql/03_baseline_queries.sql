USE olist;

-- Q1: scalar filter on amounts
SELECT COUNT(*) AS big_payments
FROM order_payments
WHERE payment_value >= 200;

-- Q2: range on timestamp
SELECT COUNT(*) AS orders_2017
FROM orders
WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp <  '2018-01-01';

-- Q3: amount aggregation
SELECT payment_type, ROUND(SUM(payment_value),2) total
FROM order_payments
GROUP BY payment_type
ORDER BY total DESC;

-- Q4: join and filter by freight value
SELECT o.order_status, COUNT(*) cnt
FROM orders o
JOIN order_items i USING(order_id)
WHERE i.freight_value > 50
GROUP BY o.order_status;

-- Q5: text search (no index yet)
SELECT COUNT(*) AS matches
FROM order_reviews
WHERE review_comment_message LIKE '%entrega%';
