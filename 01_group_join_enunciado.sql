-- ==============================================
-- SECCIÓN A) 30 CONSULTAS CON JOIN DE 2 TABLAS
-- ==============================================

USE sakila;

-- 1:  Para cada actor, muestra el número total de películas en las que aparece; es decir, cuenta cuántas filas de film_actor corresponden a cada actor.

SELECT CONCAT(first_name, '',last_name) AS actor, COUNT(film_id)
FROM actor 
		JOIN film_actor USING(actor_id)
GROUP BY actor_id;

-- 2:  Lista solo los actores que participan en 20 o más películas (umbral alto) con su conteo.

SELECT CONCAT(first_name, '',last_name) AS actor, COUNT(film_id) AS Peliculas_actor
FROM actor
		JOIN film_actor USING(actor_id)
GROUP BY actor_id
HAVING Peliculas_actor >= 20;

-- 3:  Para cada idioma, indica cuántas películas están catalogadas en ese idioma.

SELECT name, COUNT(film_id) AS Total_peliculas
FROM film
	JOIN language USING(language_id)
GROUP BY name;

-- 4:  Muestra el promedio de duración (length) de las películas por idioma y filtra aquellos idiomas con duración media estrictamente mayor a 110 minutos.

SELECT name, AVG(length) AS promedio_duracion
FROM film
	JOIN language USING(language_id)
GROUP BY name
HAVING promedio_duracion >= 110;

-- 5:  Para cada película, muestra cuántas copias hay en el inventario.

SELECT film_id, title, COUNT(film_id) AS copias
FROM film
	JOIN inventory USING(film_id)
GROUP BY film_id;


-- 6:  Lista solo las películas que tienen al menos 5 copias en inventario.

SELECT film_id, title, COUNT(film_id) AS copias
FROM film
	JOIN inventory USING(film_id)
GROUP BY film_id
HAVING copias >= 5;

-- 7:  Para cada artículo de inventario, cuenta cuántos alquileres se han realizado.

SELECT inventory_id, COUNT(rental_id) AS rental
FROM inventory
	JOIN rental USING (inventory_id)
GROUP BY inventory_id;


-- 8:  Para cada cliente, muestra cuántos alquileres ha realizado en total.

SELECT customer_id, CONCAT(first_name, '', last_name) AS nombre, COUNT(rental_id) AS renta
FROM customer
	JOIN rental USING(customer_id)
GROUP BY customer_id;

-- 9:  Lista los clientes con 30 o más alquileres acumulados.

SELECT customer_id, CONCAT(first_name, '', last_name) AS nombre, COUNT(rental_id) AS renta
FROM customer
	JOIN rental USING (customer_id)
GROUP BY customer_id
HAVING renta >= 30;

-- 10:  Para cada cliente, muestra el total de pagos (suma en euros/dólares) que ha realizado.

SELECT customer_id, CONCAT(first_name, '', last_name), SUM(amount) AS amountTotal
FROM customer
	JOIN payment USING (customer_id)
GROUP BY customer_id;

-- 11:  Muestra los clientes cuyo importe total pagado es al menos 200.

SELECT customer_id, CONCAT(first_name, '', last_name), SUM(amount) AS amountTotal
FROM customer
	JOIN payment USING (customer_id)
GROUP BY customer_id
HAVING amountTotal >= 200;

-- 12:  Para cada empleado (staff), muestra el número de pagos que ha procesado.

SELECT staff_id, CONCAT(first_name, '', last_name), COUNT(payment_id) AS  Pagos_Procesados
FROM staff 
	JOIN payment USING (staff_id)
GROUP BY staff_id;

-- 13:  Para cada empleado, muestra el importe total procesado.

SELECT staff_id, CONCAT(first_name, '', last_name) AS nombre, SUM(amount) AS Total_importe
FROM staff 
	JOIN payment USING(staff_id)
GROUP BY staff_id;

-- 14:  Para cada tienda, cuenta cuántos artículos de inventario tiene.

SELECT store_id, COUNT(inventory_id) AS cantidad_articulos
FROM store
	JOIN inventory USING(store_id)
GROUP BY store_id;

-- 15:  Para cada tienda, cuenta cuántos clientes tiene asignados.

SELECT store_id, COUNT(cr.address_id) AS customers_in_store
FROM store
	JOIN customer cr USING(store_id)
GROUP BY store_id;

-- 16:  Para cada tienda, cuenta cuántos empleados (staff) tiene asignados.

SELECT store_id, COUNT(staff_id) AS staff_in_store
FROM store
	JOIN staff USING(store_id)
GROUP BY store_id;


-- 17:  Para cada dirección (address), cuenta cuántas tiendas hay ubicadas ahí (debería ser 0/1 en datos estándar).

SELECT address_id, address, COUNT(store_id) AS stores_here
FROM address
	JOIN store USING(address_id)
GROUP BY address_id;

-- 18:  Para cada dirección, cuenta cuántos empleados residen en esa dirección.

SELECT address_id, address, COUNT(staff_id) AS staff_here
FROM address
	JOIN staff USING(address_id)
GROUP BY address_id;

-- 19:  Para cada dirección, cuenta cuántos clientes residen ahí.

SELECT address_id, address, COUNT(customer_id) AS customer_here
FROM address
	JOIN customer USING (address_id)
GROUP BY address_id;

-- 20:  Para cada ciudad, cuenta cuántas direcciones hay registradas.

SELECT city_id, city, COUNT(address_id) AS addresses_in_city
FROM city
	JOIN address USING (city_id)
GROUP BY city_id;

-- 21:  Para cada país, cuenta cuántas ciudades existen.

SELECT country_id, country, COUNT(city_id) AS cities_in_country
FROM country
	JOIN city USING(country_id)
GROUP BY country_id;

-- 22:  Para cada idioma, calcula la duración media de películas y muestra solo los idiomas con media entre 90 y 120 inclusive.

SELECT language_id, name, AVG(length)
FROM language
	JOIN film USING(language_id)
GROUP BY language_id
HAVING AVG(length) BETWEEN 90 AND 120;


-- 23:  Para cada película, cuenta el número de alquileres que se han hecho de cualquiera de sus copias (usando inventario).alter

SELECT film_id, title, COUNT(rental_id) AS total_rentals
FROM film
	JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
GROUP BY film_id;

-- 24:  Para cada cliente, cuenta cuántos pagos ha realizado en 2005 (usando el año de payment_date).

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(payment_id) AS payments_2005
FROM customer
	JOIN payment USING(customer_id)
WHERE payment_date > '2005-01-01'
GROUP BY customer_id;

-- 25:  Para cada película, muestra el promedio de tarifa de alquiler (rental_rate) de las copias existentes (es un promedio redundante pero válido).

SELECT film_id, title, AVG(rental_rate)
FROM film
	JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
GROUP BY film_id;

-- 26:  Para cada actor, muestra la duración media (length) de sus películas.

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre, AVG(length) AS duracion_media
FROM actor
	JOIN film_actor USING(actor_id)
    JOIN film USING(film_id)
GROUP BY actor_id;

-- 27:  Para cada ciudad, cuenta cuántos clientes hay (usando la relación cliente->address->city requiere 3 tablas; aquí contamos direcciones por ciudad).

SELECT city_id, city, COUNT(customer_id) AS total_addresses
FROM city
	JOIN address USING(city_id)
    JOIN customer USING(address_id)
GROUP BY city_id;

-- 28:  Para cada película, cuenta cuántos actores tiene asociados.

SELECT film_id, title, COUNT(actor_id) AS actors_in_film
FROM film 
	JOIN film_actor USING(film_id)
GROUP BY film_id;

-- 29:  Para cada categoría (por id), cuenta cuántas películas pertenecen a ella (sin nombre de categoría para mantener 2 tablas).

SELECT category_id, COUNT(film_id) AS films_in_category
FROM category
	JOIN film_category USING(category_id)
GROUP BY category_id;

-- 30:  Para cada tienda, cuenta cuántos alquileres totales se originan en su inventario.

SELECT store_id, COUNT(rental_id) AS rentals_by_store_inventoryhh
FROM store
	JOIN inventory USING(store_id)
    JOIN rental USING(inventory_id)
GROUP BY store_id;

-- ==============================================
-- SECCIÓN B) 30 CONSULTAS CON JOIN DE 3 TABLAS
-- ==============================================
-- 31:  Para cada actor, cuenta cuántas películas tiene y muestra solo los que superan 15 películas.

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(film_id) AS films_by_actor
FROM actor
	JOIN film_actor USING(actor_id)
    JOIN film USING(film_id)
GROUP BY actor_id
HAVING films_by_actor > 15;

-- 32:  Para cada categoría (por nombre), cuenta cuántas películas hay en esa categoría.

SELECT category_id, name, COUNT(film_id) AS films_in_category
FROM category
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
GROUP BY category_id;

-- 33:  Para cada película, cuenta cuántos alquileres se han hecho de sus copias.

SELECT film_id, title, COUNT(rental_id) AS rentals_of_film
FROM film
	JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
GROUP BY film_id;

-- 34:  Para cada cliente, suma el importe pagado en 2005 y filtra clientes con total >= 150.

SELECT customer_id, SUM(amount) AS suma_importe
FROM customer
	JOIN payment USING(customer_id)
GROUP BY customer_id
HAVING suma_importe >= 150;

-- 35:  Para cada tienda, suma el importe cobrado por todos sus empleados.

SELECT store_id, SUM(amount) AS revenue_by_store_staff
FROM store
	JOIN staff USING(store_id)
    JOIN payment USING(staff_id)
GROUP BY store_id;

-- 36:  Para cada ciudad, cuenta cuántos empleados residen ahí (staff -> address -> city).

SELECT city_id, city, COUNT(staff_id) AS staff_in_city
FROM city
	JOIN address USING(city_id)
    JOIN staff USING(address_id)
GROUP BY city_id;

-- 37:  Para cada ciudad, cuenta cuántas tiendas existen (store -> address -> city).

SELECT city_id, city, COUNT(store_id) AS stores_in_city
FROM city
	JOIN address USING(city_id)
    JOIN store USING(address_id)
GROUP BY city_id;

-- 38:  Para cada actor, calcula la duración media de sus películas del año 2006.

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre, AVG(length) AS duracion_media
FROM actor
	JOIN film_actor USING(actor_id)
    JOIN film f USING(film_id)
WHERE release_year = 2006
GROUP BY actor_id;

-- 39:  Para cada categoría, calcula la duración media y muestra solo las que superan 120.

SELECT category_id, name, AVG(length) AS duracion_media
FROM category
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
GROUP BY category_id
HAVING duracion_media > 120;

-- 40:  Para cada idioma, suma las tarifas de alquiler (rental_rate) de todas sus películas.

SELECT language_id, name, SUM(rental_rate) AS Suma_tarifas
FROM language
	JOIN film USING(language_id)
    JOIN inventory USING(film_id)
GROUP BY language_id;

-- 41:  Para cada cliente, cuenta cuántos alquileres realizó en fines de semana (SÁB-DO) usando DAYOFWEEK (1=Domingo).

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(rental_id) AS weekend_rentals
FROM customer
	JOIN rental USING(customer_id)
WHERE DAYOFWEEK(rental_date) IN (1, 7)
GROUP BY customer_id;

-- 42:  Para cada actor, muestra el total de títulos distintos en los que participa (equivale a COUNT DISTINCT, sin subconsulta).

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(DISTINCT film_id) AS total_peliculas
FROM actor
	JOIN film_actor USING(actor_id)
    JOIN film USING(film_id)
GROUP BY actor_id;

-- 43:  Para cada ciudad, cuenta cuántos clientes residen ahí (customer -> address -> city).

SELECT city_id, city, COUNT(customer_id) AS customers_in_city
FROM city
	JOIN address USING(city_id)
    JOIN customer USING(address_id)
GROUP BY city_id;

-- 44:  Para cada categoría, muestra cuántos actores distintos participan en películas de esa categoría.

SELECT category_id, c.name, COUNT(DISTINCT actor_id) AS actors_in_category
FROM category c
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
    JOIN film_actor USING(film_id)
GROUP BY category_id;

-- 45:  Para cada tienda, cuenta cuántas copias totales (inventario) tiene de películas en 2006.

SELECT store_id, COUNT(inventory_id) AS copies_2006
FROM store
	JOIN inventory USING(store_id)
    JOIN film USING(film_id)
WHERE release_year = 2006
GROUP BY store_id;

-- 46:  Para cada cliente, suma el total pagado por alquileres cuyo empleado pertenece a la tienda 1.

SELECT customer_id, CONCAT(c.first_name, ' ', c.last_name) AS nombre,  SUM(p.amount) AS total_pagado
FROM customer c
	JOIN payment p USING(customer_id)
    JOIN staff s USING(staff_id)
WHERE s.store_id = 1
GROUP BY customer_id;

-- 47:  Para cada película, cuenta cuántos actores tienen el apellido de longitud >= 5.

SELECT film_id, title, COUNT(actor_id) AS actors_lastname_len5plus
FROM film
	JOIN film_actor USING(film_id)
	JOIN actor USING(actor_id)
WHERE length(last_name) >= 5
GROUP BY film_id;

-- 48:  Para cada categoría, suma la duración total (length) de sus películas.

SELECT category_id, name, SUM(f.length) AS duracion_total
FROM category
	JOIN film_category USING(category_id)
    JOIN film f USING(film_id)
GROUP BY category_id;

-- 49:  Para cada ciudad, suma los importes pagados por clientes que residen en esa ciudad.

SELECT city_id, city, SUM(amount) AS total_paid
FROM city
	JOIN address USING(city_id)
    JOIN customer USING(address_id)
    JOIN payment USING(customer_id)
GROUP BY city_id;

-- 50:  Para cada idioma, cuenta cuántos actores distintos participan en películas de ese idioma.

SELECT language_id, name, count(DISTINCT actor_id) AS actors_in_language
FROM language
	JOIN film USING(language_id)
    JOIN film_actor USING(film_id)
GROUP BY language_id;

-- 51:  Para cada tienda, cuenta cuántos clientes activos (active=1) tiene.

SELECT store_id, COUNT(customer_id) AS active_customers
FROM store
	JOIN customer USING(store_id)
WHERE active = 1
GROUP BY store_id;

-- 52:  Para cada cliente, cuenta en cuántas categorías distintas ha alquilado (aprox. vía film_category; requiere 4 tablas, aquí contamos películas 2006 por inventario).

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(DISTINCT category_id) rentals_2006
FROM customer
	JOIN rental USING(customer_id)
    JOIN inventory USING(inventory_id)
    JOIN film_category USING(film_id)
WHERE YEAR(rental_date) = 2006
GROUP BY customer_id;

-- 53:  Para cada empleado, cuenta cuántos clientes diferentes le han pagado.

SELECT staff_id, CONCAT(s.first_name, ' ', s.last_name) AS nombre, COUNT(DISTINCT customer_id) AS distinct_customers_paid
FROM staff s
	JOIN payment USING(staff_id)
	JOIN customer USING(customer_id)
GROUP BY staff_id;

-- 54:  Para cada ciudad, cuenta cuántas películas del año 2006 han sido alquiladas por residentes en esa ciudad.

SELECT city_id, city, COUNT(rental_id) AS rentals_2006_by_city
FROM city
	JOIN address USING(city_id)
    JOIN customer USING(address_id)
    JOIN rental USING(customer_id)
    JOIN inventory USING(inventory_id)
    JOIN film USING(film_id)
WHERE YEAR(rental_date) = 2006
GROUP BY city_id;

-- 55:  Para cada categoría, calcula el promedio de replacement_cost de sus películas.

SELECT category_id, name, AVG(replacement_cost) AS avg_replacement_cost
FROM category 
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
GROUP BY category_id;

-- 56:  Para cada tienda, suma los importes cobrados en 2006 (vía empleados de esa tienda).

SELECT store_id, SUM(amount) AS revenue_2006
FROM store
	JOIN staff USING(store_id)
    JOIN payment USING(staff_id)
WHERE YEAR(payment_date) = 2006
GROUP BY store_id;

-- 57:  Para cada actor, cuenta cuántas películas tienen título de más de 12 caracteres.

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(film_id) AS films_title_len_gt12
FROM actor
	JOIN film_actor USING(actor_id)
    JOIN film USING(film_id)
WHERE length(title) > 12
GROUP BY actor_id;

-- 58:  Para cada ciudad, calcula la suma de pagos de 2005 y filtra las ciudades con total >= 300.

SELECT city_id, city, SUM(amount) AS suma_pagos_2005
FROM city
	JOIN address USING(city_id)
    JOIN staff USING(address_id)
    JOIN payment USING(staff_id)
WHERE payment_date = 2005
GROUP BY city_id
HAVING suma_pagos_2005 >= 300;

-- 59:  Para cada categoría, cuenta cuántas películas tienen rating 'PG' o 'PG-13'.

SELECT category_id, name, COUNT(film_id) AS films_pg_pg13
FROM category
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
WHERE rating IN ('PG', 'PG-13')
GROUP BY category_id;

-- 60:  Para cada cliente, calcula el total pagado en pagos procesados por el empleado 2.

SELECT customer_id, CONCAT(c.first_name, ' ', c.last_name) AS nombre, SUM(amount) AS total_paid_by_staff2
FROM customer c
	JOIN payment USING(customer_id)
    JOIN staff USING(staff_id)
WHERE staff_id = 2
GROUP BY customer_id;

-- ==============================================
-- SECCIÓN C) 20 CONSULTAS CON JOIN DE 4 TABLAS
-- ==============================================
-- 61:  Para cada ciudad, cuenta cuántos clientes hay y muestra solo ciudades con 10 o más clientes.

SELECT city_id, city, COUNT(customer_id) AS 10_clientes_en_ciudad
FROM city
	JOIN address USING(city_id)
    JOIN customer USING(address_id)
GROUP BY city_id
HAVING 10_clientes_en_ciudad >= 10;

-- 62:  Para cada actor, cuenta cuántos alquileres totales suman todas sus películas.

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre,COUNT(rental_id) AS rentals_for_actor
FROM actor 
	JOIN film_actor USING(actor_id)
    JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
GROUP BY actor_id;

-- 63:  Para cada categoría, suma los importes pagados derivados de películas de esa categoría.

SELECT category_id, name, SUM(amount) AS revenue_by_category
FROM category
	JOIN film_category USING(category_id)
    JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
    JOIN payment USING(rental_id)
GROUP BY category_id;

-- 64:  Para cada ciudad, suma los importes pagados por clientes residentes en esa ciudad en 2005.

SELECT city_id, city, SUM(amount) AS total_paid_2005
FROM city
    JOIN address USING(city_id)
    JOIN customer USING(address_id)
    JOIN payment USING(customer_id)
WHERE YEAR(payment_date) = 2005
GROUP BY city_id;

-- 65:  Para cada tienda, cuenta cuántos actores distintos aparecen en las películas de su inventario.

SELECT store_id, COUNT(DISTINCT actor_id) AS distinct_actors_in_store_inventory
FROM store
    JOIN inventory USING(store_id)
    JOIN film_actor USING(film_id)
    JOIN actor USING(actor_id)
GROUP BY store_id;

-- 66:  Para cada idioma, cuenta cuántos alquileres totales se han hecho de películas en ese idioma.

SELECT language_id, name, COUNT(rental_id) AS rentals_in_language
FROM language
    JOIN film USING(language_id)
    JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
GROUP BY language_id;

-- 67:  Para cada cliente, cuenta en cuántos meses distintos de 2005 realizó pagos (meses distintos).

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(DISTINCT MONTH(payment_date)) AS active_months_2005
FROM customer
    JOIN payment USING(customer_id)
WHERE YEAR(payment_date) = 2005
GROUP BY customer_id;

-- 68:  Para cada categoría, calcula la duración media de las películas alquiladas (considerando solo películas alquiladas).

SELECT category_id, name, AVG(length) AS duracion_media
FROM category
    JOIN film_category USING(category_id)
    JOIN film USING(film_id)
    JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
GROUP BY category_id;

-- 69:  Para cada país, cuenta cuántos clientes hay (country -> city -> address -> customer).

SELECT country_id, country, COUNT(customer_id) AS Numero_clientes
FROM country
    JOIN city USING(country_id)
    JOIN address USING(city_id)
    JOIN customer USING(address_id)
GROUP BY country_id;

-- 70:  Para cada país, suma los importes pagados por sus clientes.

SELECT country_id, country, SUM(amount) AS Importe_Cliente
FROM country
    JOIN city USING(country_id)
    JOIN address USING(city_id)
    JOIN customer USING(address_id)
    JOIN payment USING(customer_id)
GROUP BY country_id;

-- 71:  Para cada tienda, cuenta cuántas categorías distintas existen en su inventario.

SELECT store_id, COUNT(DISTINCT category_id) AS distinct_categories_in_store
FROM store
    JOIN inventory USING(store_id)
    JOIN film_category USING(film_id)
    JOIN category USING(category_id)
GROUP BY store_id;

-- 72:  Para cada tienda, suma la recaudación por categoría (resultado agregado por tienda y categoría).

SELECT 
    s.store_id, c.category_id, c.name, SUM(amount) AS revenue
FROM store s
    JOIN staff USING (store_id)
    JOIN payment USING (staff_id)
    JOIN rental USING (rental_id)
    JOIN inventory USING(inventory_id)
    JOIN film USING(film_id)
    JOIN film_category USING (film_id)
    JOIN category c USING (category_id)
GROUP BY store_id, category_id;

-- 73:  Para cada actor, cuenta en cuántas tiendas distintas se han alquilado sus películas.

SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(DISTINCT store_id) AS stores_with_actor_films_rented
FROM actor
	JOIN film_actor USING(actor_id)
    JOIN film USING(film_id)
    JOIN inventory USING(film_id)
    JOIN store USING(store_id)
GROUP BY actor_id;

-- 74:  Para cada categoría, cuenta cuántos clientes distintos han alquilado películas de esa categoría.

SELECT category_id, c.name, COUNT(DISTINCT customer_id) AS distinct_customers
FROM category c
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
    JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
    JOIN customer USING(customer_id)
GROUP BY category_id;

-- 75:  Para cada idioma, cuenta cuántos actores distintos participan en películas alquiladas en ese idioma.

SELECT language_id, name, COUNT(DISTINCT actor_id) AS  actors_in_rented_language_films
FROM language
	JOIN film USING(language_id)
    JOIN film_actor USING(film_id)
    JOIN actor USING(actor_id)
GROUP BY language_id;

-- 76:  Para cada país, cuenta cuántas tiendas hay (país->ciudad->address->store).

SELECT country_id, country, COUNT(store_id) AS stores_in_country
FROM country
	JOIN city USING(country_id)
    JOIN address USING(city_id)
    JOIN store USING(address_id)
GROUP BY country_id;

-- 77:  Para cada cliente, cuenta los alquileres en los que la devolución (return_date) fue el mismo día del alquiler.

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS nombre, COUNT(rental_id) AS same_day_returns
FROM rental
	JOIN customer USING(customer_id)
WHERE DATE(rental_date) = DATE(return_date)
GROUP BY customer_id;

-- 78:  Para cada tienda, cuenta cuántos clientes distintos realizaron pagos en 2005.

SELECT store_id, COUNT(DISTINCT customer_id) AS distinct_customers_2005
FROM store
	JOIN staff USING(store_id)
    JOIN payment USING(staff_id)
WHERE YEAR(payment_date) = 2005
GROUP BY store_id;

-- 79:  Para cada categoría, cuenta cuántas películas con título de longitud > 15 han sido alquiladas.

SELECT category_id, name, COUNT(film_id) AS rentals_long_title
FROM category
	JOIN film_category USING(category_id)
    JOIN film USING(film_id)
    JOIN inventory USING(film_id)
    JOIN rental USING(inventory_id)
WHERE length(title) > 15
GROUP BY category_id;

-- 80:  Para cada país, suma los pagos procesados por los empleados de las tiendas ubicadas en ese país.

SELECT country_id, country, SUM(amount) AS revenue_by_country_staff
FROM country
	JOIN city USING(country_id)
    JOIN address USING(city_id)
    JOIN staff USING(address_id)
    JOIN payment USING(staff_id)
GROUP BY country_id;

-- ==============================================
-- SECCIÓN D) 20 CONSULTAS EXTRA (DIFICULTAD +), <=4 JOINS
-- ==============================================
-- 81:  Para cada cliente, muestra el total pagado con IVA teórico del 21% aplicado (total*1.21), redondeado a 2 decimales.
-- 82:  Para cada hora del día (0-23), cuenta cuántos alquileres se iniciaron en esa hora.
-- 83:  Para cada tienda, muestra la media de length de las películas alquiladas en 2005 y filtra las tiendas con media >= 100.
-- 84:  Para cada categoría, muestra la media de replacement_cost de las películas alquiladas un domingo.
-- 85:  Para cada empleado, muestra el importe total por pagos realizados entre las 00:00 y 06:00 (inclusive 00:00, exclusivo 06:00).
-- 86:  Para cada actor, cuenta cuántas de sus películas tienen un título que contiene la palabra 'LOVE' (mayúsculas).
-- 87:  Para cada idioma, muestra el total de pagos de alquileres de películas en ese idioma.
-- 88:  Para cada cliente, cuenta en cuántos días distintos de 2005 realizó algún alquiler.
-- 89:  Para cada categoría, calcula la longitud media de títulos (número de caracteres) de sus películas alquiladas.
-- 90:  Para cada tienda, cuenta cuántos clientes distintos alquilaron en el primer trimestre de 2006 (enero-marzo).
-- 91:  Para cada país, cuenta cuántas categorías diferentes han sido alquiladas por clientes residentes en ese país.
-- 92:  Para cada cliente, muestra el importe medio de sus pagos redondeado a 2 decimales, solo si ha hecho al menos 10 pagos.
-- 93:  Para cada categoría, muestra el número de películas con replacement_cost > 20 que hayan sido alquiladas al menos una vez.
-- 94:  Para cada tienda, suma los importes pagados en fines de semana.
-- 95:  Para cada actor, cuenta cuántas películas suyas fueron alquiladas por al menos 5 clientes distintos (se cuenta alquileres y luego se filtra por HAVING).
-- 96:  Para cada idioma, muestra el número de películas cuyo título empieza por la letra 'A' y que han sido alquiladas.
-- 97:  Para cada país, suma el importe total de pagos realizados por clientes residentes y filtra países con total >= 1000.
-- 98:  Para cada cliente, cuenta cuántos días han pasado entre su primer y su último alquiler en 2005 (diferencia de fechas), mostrando solo clientes con >= 5 alquileres en 2005.
--     (Se evita subconsulta calculando sobre el conjunto agrupado por cliente y usando MIN/MAX de rental_date en 2005).
-- 99:  Para cada tienda, muestra la media de importes cobrados por transacción en el año 2006, con dos decimales.
-- 100:  Para cada categoría, calcula la media de duración (length) de películas alquiladas en 2006 y ordénalas descendentemente por dicha media.
