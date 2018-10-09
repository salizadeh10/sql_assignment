USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in 
-- upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name,  ' ', last_name) AS ' Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, 'Joe.' What is one query would you 
-- use to obtain this information?SELECT actor_id, first_name, last_name
SELECT *
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name 
FROM actor
WHERE last_name LIKE '%LI%';

-- 2d. Using `IN`, display the `country_id` and `country` columns of the 
-- following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you 
-- will be performing queries on a description, so create a column in the 
-- table `actor` named `description` and use the data type `BLOB` (Make sure
-- to research the type `BLOB`, as the difference between it and `VARCHAR` 
-- are significant).
ALTER TABLE actor
ADD (
		description BLOB
	);

-- 3b. Very quickly you realize that entering descriptions for each actor is
-- too much effort. Delete the `description` column.
ALTER TABLE actor
DROP description;


-- 4a. List the last names of actors, as well as how many actors have that 
-- last name.
SELECT last_name, COUNT(*) AS 'count'
FROM actor
GROUP BY last_name
HAVING count > 2;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
UPDATE actor
SET first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` 
-- table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor
SET first_name = 'GROUCHO', last_name = 'WILLIAMS'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the `address` table. Which query 
-- would you use to re-create it?
DESCRIBE sakila.address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON address.address_id = staff.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT first_name, last_name, SUM(amount) AS total_amount
FROM staff
JOIN payment USING (staff_id)
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables `film_actor` and `film`. Use inner join.
SELECT title, COUNT(actor_id)
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in 
-- the inventory system?
SELECT title, COUNT(inventory_id)
FROM film 
INNER JOIN inventory  
ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, 
-- list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) AS total_amount
FROM customer c
JOIN payment p USING (customer_id)
WHERE c.customer_id = p.customer_id
GROUP BY customer_id
ORDER BY last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely 
-- resurgence. As an unintended consequence, films starting with the
--  letters `K` and `Q` have also soared in popularity. Use subqueries to 
-- display the titles of movies starting with the letters `K` and `Q` whose 
-- language is English.
SELECT * FROM film
WHERE title LIKE 'K%'
 OR title LIKE 'Q%'
 AND language_id = (SELECT language_id FROM language where name='English');
 
-- 7b. Use subqueries to display all actors who appear in the 
-- film `Alone Trip`.
SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
	IN (SELECT film_id from film where title='ALONE TRIP'));
    
-- 7c. You want to run an email marketing campaign in Canada,
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON (c.address_id = a.address_id)
JOIN city cit ON (a.city_id=cit.city_id)
JOIN country cnt ON (cit.country_id=cnt.country_id)

-- 7d. Sales have been lagging among young families, and you wish to
-- target all family movies for a promotion. Identify all movies categorized 
-- as _family_ films.
SELECT f.title
FROM film f
JOIN film_category fc ON (f.film_id = fc.film_id)
JOIN category c on (c.category_id = fc.film_id);

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(f.film_id) AS 'rental_frequency'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY rental_frequency DESC;

-- * 7f. Write a query to display how much business, in dollars, 
-- each store brought in.
SELECT s.store_id, SUM(p.amount) 
FROM payment p
JOIN staff s ON (s.staff_id=p.staff_id)
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, cnt.country
FROM store s
JOIN address a ON (a.address_id = s.address_id)
JOIN city c ON (c.city_id = a.city_id)
JOIN country cnt ON (cnt.country_id = c.country_id);