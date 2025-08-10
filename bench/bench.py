import time, statistics, mysql.connector as mc

CONFIG = dict(user="root", password="Secret5555", host="127.0.0.1", database="olist")

QUERIES = {
  "Q1_big_payments": """SELECT COUNT(*) FROM order_payments WHERE payment_value >= 200;""",
  "Q2_orders_2017": """SELECT COUNT(*) FROM orders
                       WHERE order_purchase_timestamp >= '2017-01-01'
                         AND order_purchase_timestamp < '2018-01-01';""",
  "Q3_sum_by_type": """SELECT payment_type, SUM(payment_value)
                       FROM order_payments GROUP BY payment_type;""",
  "Q4_join_freight_gt_50": """SELECT o.order_status, COUNT(*)
                              FROM orders o JOIN order_items i USING(order_id)
                              WHERE i.freight_value > 50
                              GROUP BY o.order_status;""",
  # Text search: LIKE vs FULLTEXT
  "Q5a_review_like_entrega": """SELECT COUNT(*) FROM order_reviews
                                WHERE review_comment_message LIKE '%entrega%';""",
  "Q5b_review_match_entrega": """SELECT COUNT(*) FROM order_reviews
                                WHERE MATCH(review_comment_message)
                                AGAINST('entrega' IN NATURAL LANGUAGE MODE);""",
  "Q6_match_boolean_entrega_atraso": """SELECT COUNT(*) FROM order_reviews
                                       WHERE MATCH(review_comment_message)
                                       AGAINST('+entrega +atraso' IN BOOLEAN MODE);"""
}

def time_query(cur, sql, warmups=2, runs=7):
    for _ in range(warmups):
        cur.execute(sql); cur.fetchall()
    times = []
    for _ in range(runs):
        t0 = time.perf_counter()
        cur.execute(sql); cur.fetchall()
        times.append(time.perf_counter() - t0)
    return statistics.median(times)

if __name__ == "__main__":
    con = mc.connect(**CONFIG)
    cur = con.cursor()
    for name, sql in QUERIES.items():
        t = time_query(cur, sql)
        print(f"{name}: {t:.4f}s")
    cur.close(); con.close()
