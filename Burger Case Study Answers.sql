SELECT * FROM burger_names ;
SELECT * FROM burger_runner ;
SELECT * FROM customer_orders ;
SELECT * FROM runner_orders ;

-- 1. How many burgers were ordered?

SELECT COUNT(Order_id) as Total_Orders FROM customer_orders ;

-- 2. How many unique customer orders were made?

SELECT COUNT(distinct customer_id) AS Unique_Customer_Orders FROM customer_orders ;

-- 3. How many successful orders were delivered by each runner?

SELECT runner_id , COUNT(order_id) As Successfull_orders
FROM runner_orders
WHERE cancellation is NULL
GROUP BY runner_id ;

-- 4. How many of each type of burger was delivered?

SELECT C.burger_id , COUNT(c.order_id) as Burger_Delivered
FROM customer_orders As C
JOIN runner_orders As R ON C.order_id = R.order_id
WHERE R.cancellation IS NULL 
GROUP BY burger_id ;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT C.customer_id , B.burger_name , COUNT(C.order_id) as burger_ordered
FROM customer_orders AS C
JOIN burger_names AS B ON B.burger_id = C.burger_id
GROUP BY B.burger_name , C.customer_id
ORDER BY C.customer_id;

-- 6. What was the maximum number of burgers delivered in a single order?

SELECT C.order_id , COUNT(C.burger_id) AS burgers_Delivered
FROM customer_orders AS C
JOIN runner_orders AS R 
ON r.order_id=C.order_id
WHERE r.distance!=0
GROUP BY C.order_id
ORDER BY burgers_Delivered DESC
LIMIT 1 ;

-- 7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?

SELECT c.customer_id,
 SUM(CASE 
  WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL  THEN 1
  ELSE 0
  END) AS at_least_1_change,
 SUM(CASE 
  WHEN c.exclusions IS NULL  AND c.extras IS NULL  THEN 1 
  ELSE 0
  END) AS no_change
FROM customer_orders AS c
JOIN runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 8. What was the total volume of burgers ordered for each hour of the day?

SELECT EXTRACT(HOUR from order_time) AS hour_of_day, 
 COUNT(order_id) AS burger_count
FROM customer_orders
GROUP BY EXTRACT(HOUR from order_time)
ORDER BY hour_of_day;

-- 9. How many runners signed up for each 1 week period?

SELECT EXTRACT(WEEK from registration_date) AS registration_week,
 COUNT(runner_id) AS runner_signup
FROM burger_runner
GROUP BY EXTRACT(WEEK from registration_date);

-- 10.What was the average distance travelled for each customer?

SELECT c.customer_id, AVG(r.distance) AS avg_distance
FROM customer_orders AS c
JOIN runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.duration != 0
GROUP BY c.customer_id;

