Use sakila;  

-- 1a. Display the first and last names of all actors from the table actor.
Select first_name as 'Actor First Name'
	, last_name as 'Actor Last Name'
From actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select CONCAT(first_name, " ", last_name) as 'Actor Name'
From actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select  actor_id, first_name, last_name
From actor
Where first_name LIKE 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
Select actor_id, first_name, last_name
FROM actor
Where last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
Select last_name, first_name
FROM Actor
Where last_name LIKE '%LI%'
Order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
Select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
Alter Table actor
Add Column description blob; 

Select first_name, description
FROM actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
Alter Table actor
Drop Column description;

Select *
FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
Select last_name, count(*) As 'number of actors with this last name'
From actor
Group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Select last_name, count(*) As 'number of actors with this last name'
From actor
Group by last_name
Having count(*) > 1;

-- **********Help*******
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
Update actor
Set first_name = "Harpo" 
Where first_name = "Groucho" AND last_name = "Williams";

Select first_name, last_name
From Actor
Where First_name = "Harpo";


-- ********Help ********
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
Update actor
set first_name = "Groucho"
Where first_name = "Harpo";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
Select s.first_name, s.last_name, a.address
From staff s
	Left Join address a on s.address_id = a.address_id;

-- **********HELP*************
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
Select s.first_name, s.last_name, sum(amount)
From staff s
	Left Join payment p on s.staff_id = p.staff_id
Group by s.staff_id
Having (p.payment_date between '2005-08-01' and '2005-08-31'); 


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
Select f.title, count(Actor_id)
from film f
	Inner Join film_actor fa on f.film_id = fa.film_id
Group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
Select f.title, count(i.inventory_id)
from inventory i
    inner join film f on i.film_id = f.film_id
Group by f.title
Having title = "Hunchback Impossible";



-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
Select c.last_name, sum(amount)
from customer c
Join payment p on c.customer_id = p.customer_id
group by p.customer_id
Order by c.last_name;

-- 7a.  Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
Select title
from film
where title LIKE 'K%' OR title in (Select title from film where title LIKE 'Q%');


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select a.actor_id, a.last_name, a.first_name
from film f
Inner join film_actor fa on f.film_id = fa.film_id
Inner Join actor a on fa.actor_id = a.actor_id
Where f.film_id in (select film_id from film where title = "Alone Trip");

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
Select first_name, last_name, email
From customer c
Inner Join address a on a.address_id = c.address_id
Inner Join city ct on ct.city_id = a.city_id
Inner join country cy on cy.country_id = ct.country_id
where country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Select title, c.name
from film f
Left Join film_category fc on fc.film_id = f.film_id
Left Join category c on c.category_id = fc.category_id
where c.name = "family";

-- 7e. Display the most frequently rented movies in descending order.
Select title, count(rental_id)
from film f
Inner join inventory i on i.film_id = f.film_id
Inner join rental r on r.inventory_id = i.inventory_id
group by title
order by count(rental_id) DESC;

-- *******Help**********
-- 7f. Write a query to display how much business, in dollars, each store brought in.
Select s.store_id, sum(amount) 
from store s
join staff sf on sf.store_id = s.store_id
join payment p on p.staff_id = sf.staff_id
Group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
Select store_id, city, country
from store s
left join address a on a.address_id = s.address_id
left join city ct on ct.city_id = a.city_id
left join country cy on cy.country_id = ct.country_id;


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name, sum(amount) 
from category c
	join film_category fc on fc.category_id = c.category_id
    join film f on f.film_id = fc.film_id
    join inventory i on i.film_id = f.film_id
    join rental r on r.inventory_id =  i.inventory_id
    join payment p on p.rental_id = r.rental_id
group by c.name
order by sum(amount) desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Create View Top5 as (select c.name, sum(amount) 
from category c
	join film_category fc on fc.category_id = c.category_id
    join film f on f.film_id = fc.film_id
    join inventory i on i.film_id = f.film_id
    join rental r on r.inventory_id =  i.inventory_id
    join payment p on p.rental_id = r.rental_id
group by c.name
order by sum(amount) desc
limit 5);

-- 8b. How would you display the view that you created in 8a?
Select * from Top5;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
Drop View Top5;