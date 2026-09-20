-- ================= REVENUE & SPEND BY DEMOGRAPHICS =================

-- 1. Total revenue by gender
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;

-- 2. Average spend by age group & gender
SELECT 
    age_group,
    gender,
    ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
GROUP BY age_group, gender
ORDER BY avg_spend DESC;

-- 3. Revenue contribution by age group
SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;

-- 4. Revenue by location (top 10)
SELECT 
    location,
    SUM(purchase_amount) AS revenue
FROM customer
GROUP BY location
ORDER BY revenue DESC
LIMIT 10;


-- ================= SUBSCRIPTION & LOYALTY =================

-- 5. [MERGED] Subscription status: customer counts, avg previous purchases,
--    avg spend, and total revenue in one query
--    (combines: "Customer Loyalty by Subscription Status" +
--     "Do subscribed customers spend more?")
SELECT 
    subscription_status,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- 6. Customer segmentation: New / Returning / Loyal based on previous purchases
WITH customer_type AS (
    SELECT customer_id, previous_purchases,
    CASE 
        WHEN previous_purchases = 1 THEN 'New'
        WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_segment
    FROM customer
)
SELECT customer_segment, COUNT(*) AS "Number of Customers" 
FROM customer_type 
GROUP BY customer_segment;

-- 7. Are repeat buyers (>5 previous purchases) more likely to subscribe?
SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- 8. Top 10 highest-value customers by purchase amount
SELECT *
FROM (
    SELECT 
        customer_id,
        purchase_amount,
        previous_purchases,
        RANK() OVER (ORDER BY purchase_amount DESC) AS spend_rank
    FROM customer
) t
WHERE spend_rank <= 10;


-- ================= DISCOUNTS =================

-- 9. Discount impact on spending (avg spend & order count by discount flag)
SELECT 
    discount_applied,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    COUNT(*) AS orders
FROM customer
GROUP BY discount_applied;

-- 10. Customers who used a discount but still spent above the average
SELECT customer_id, purchase_amount 
FROM customer 
WHERE discount_applied = 'Yes' 
  AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer);

-- 11. Top 5 products with the highest % of discounted purchases
SELECT item_purchased,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


-- ================= PRODUCTS & CATEGORIES =================

-- 12. Category-wise revenue contribution
SELECT 
    category,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;

-- 13. Top 3 most purchased products within each category
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;

-- 14. Top 5 products by average review rating
SELECT item_purchased, ROUND(AVG(review_rating::numeric), 2) AS "Average Product Rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- 15. Average review rating by category
SELECT 
    category,
    AVG(review_rating) AS avg_rating
FROM customer
GROUP BY category
ORDER BY avg_rating DESC;

-- 16. Purchase frequency vs spend
SELECT 
    frequency_of_purchases,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    COUNT(customer_id) AS customer_count
FROM customer
GROUP BY frequency_of_purchases
ORDER BY avg_spend DESC;


-- ================= SHIPPING & PAYMENT =================

-- 17.Shipping type: order count and avg purchase amount

SELECT 
    shipping_type,
    COUNT(*) AS orders,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
GROUP BY shipping_type
ORDER BY orders DESC;

-- 18. Payment method popularity
SELECT 
    payment_method,
    COUNT(*) AS usage_count
FROM customer
GROUP BY payment_method
ORDER BY usage_count DESC;