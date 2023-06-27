-- Challenge
-- Creating a Customer Summary Report

-- In this exercise, you will create a customer summary report that 
-- summarizes key information about customers in the Sakila database, 
-- including their rental history and payment details. 
-- The report will be generated using a combination of views, CTEs, and temporary tables.

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW sakila.customer_rental_info AS (
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(rental_id) AS rental_count
FROM sakila.customer AS c
JOIN sakila.rental AS r
ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY COUNT(rental_id) DESC
);

SELECT * FROM customer_rental_info;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the 
-- payment table and calculate the total amount paid by each customer.

CREATE TABLE customer_rental_payment1
SELECT cri.*, SUM(p.amount) AS total_amount_paid FROM customer_rental_info AS cri
JOIN payment AS p
ON cri.customer_id = p.customer_id
GROUP BY cri.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment 
-- summary Temporary Table created in Step 2. The CTE should include the customer's name, 
-- email address, rental count, and total amount paid.

WITH cte_customer_summary_report AS (
SELECT * FROM customer_rental_payment1
)

-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.

SELECT *, (total_amount_paid/rental_count) as average_payment_per_rental FROM cte_customer_summary_report;
