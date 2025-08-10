USE olist;

ALTER TABLE order_reviews
  ADD FULLTEXT ft_review_msg (review_comment_message),
  ADD FULLTEXT ft_review_title (review_comment_title);
