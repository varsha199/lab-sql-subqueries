USE sakila;

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) FROM inventory 
WHERE film_id =
(SELECT film_id FROM film 
WHERE title = "Hunchback Impossible");

-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length FROM film
WHERE length > (SELECT AVG(length) AS avg_length FROM film);

-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT title 
FROM film  
WHERE film_id IN (SELECT film_id
FROM film_category
WHERE category_id = (
SELECT category_id FROM category
WHERE name = 'family')
);

-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email 
FROM customer AS c
JOIN address AS a ON a.address_id = c.address_id
JOIN city AS ci ON ci.city_id = a.city_id
JOIN country AS co on co.country_id = ci.country_id
WHERE co.country = 'canada';

-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT  a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS num_of_films
FROM actor AS a 
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film AS f ON f.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_of_films DESC;

SELECT film_id, title 
FROM film
WHERE film_id IN (SELECT film_id 
FROM film_actor 
WHERE actor_ID  = 107);

-- Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT f.film_id, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = (
    SELECT c.customer_id
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
    ORDER BY SUM(p.amount) DESC
    LIMIT 1
);

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, total_spent
FROM (
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_ID
) AS customer_totals
WHERE total_spent > (
SELECT AVG(total_spent)
FROM (
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
) AS totals
);