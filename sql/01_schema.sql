CREATE DATABASE IF NOT EXISTS olist DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE olist;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id              VARCHAR(32) PRIMARY KEY,
  customer_unique_id       VARCHAR(32),
  customer_zip_code_prefix INT,
  customer_city            VARCHAR(100),
  customer_state           CHAR(2)
);

DROP TABLE IF EXISTS sellers;
CREATE TABLE sellers (
  seller_id                VARCHAR(32) PRIMARY KEY,
  seller_zip_code_prefix   INT,
  seller_city              VARCHAR(100),
  seller_state             CHAR(2)
);

DROP TABLE IF EXISTS geolocation;
CREATE TABLE geolocation (
  geolocation_zip_code_prefix INT,
  geolocation_lat             DECIMAL(9,6),
  geolocation_lng             DECIMAL(9,6),
  geolocation_city            VARCHAR(100),
  geolocation_state           CHAR(2)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id                        VARCHAR(32) PRIMARY KEY,
  customer_id                     VARCHAR(32),
  order_status                    VARCHAR(20),
  order_purchase_timestamp        DATETIME,
  order_approved_at               DATETIME NULL,
  order_delivered_carrier_date    DATETIME NULL,
  order_delivered_customer_date   DATETIME NULL,
  order_estimated_delivery_date   DATETIME,
  KEY idx_orders_customer (customer_id),
  KEY idx_orders_status (order_status),
  KEY idx_orders_purchase_ts (order_purchase_timestamp)
);

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
  order_id            VARCHAR(32),
  order_item_id       INT,
  product_id          VARCHAR(32),
  seller_id           VARCHAR(32),
  shipping_limit_date DATETIME,
  price               DECIMAL(10,2),
  freight_value       DECIMAL(10,2),
  PRIMARY KEY(order_id, order_item_id),
  KEY idx_items_seller (seller_id),
  KEY idx_items_product (product_id),
  KEY idx_items_price (price),
  KEY idx_items_freight (freight_value)
);

DROP TABLE IF EXISTS order_payments;
CREATE TABLE order_payments (
  order_id             VARCHAR(32),
  payment_sequential   INT,
  payment_type         VARCHAR(20),
  payment_installments INT,
  payment_value        DECIMAL(10,2),
  PRIMARY KEY(order_id, payment_sequential),
  KEY idx_payments_value (payment_value),
  KEY idx_payments_type (payment_type)
);

DROP TABLE IF EXISTS order_reviews;
CREATE TABLE order_reviews (
  review_id              VARCHAR(32) PRIMARY KEY,
  order_id               VARCHAR(32),
  review_score           INT,
  review_comment_title   VARCHAR(255),
  review_comment_message TEXT,
  review_creation_date   DATETIME,
  review_answer_timestamp DATETIME
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id                       VARCHAR(32) PRIMARY KEY,
  product_category_name            VARCHAR(100),
  product_name_lenght              INT,
  product_description_lenght       INT,
  product_photos_qty               INT,
  product_weight_g                 INT,
  product_length_cm                INT,
  product_height_cm                INT,
  product_width_cm                 INT
);

DROP TABLE IF EXISTS product_category_name_translation;
CREATE TABLE product_category_name_translation (
  product_category_name         VARCHAR(100),
  product_category_name_english VARCHAR(100)
);
