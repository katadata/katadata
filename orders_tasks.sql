/* 1. Liczba zamówień i unikalnych klientów/Number of orders and number of unique customers */
select 
	count(order_id) as nr_of_orders
	,count(distinct customer_id) as nr_of_customers
from orders

/* 2. Średni czas dostawy/ Average delivery time */
select 
	round(avg(DATEDIFF(shipping_date, order_date))) as avg_of_time_order
	from orders

/* 3. Liczba zamówień według miasta/ Number of orders by city */
select
	delivery_city
	,count(order_id) as nr_of_orders
from orders
group by 1
order by 2 desc

/* 3A. Liczba zamówień dla miast zaczynających się na 'C'/ Number of orders for cities starting with 'C'  */
select
	delivery_city
	,count(order_id) as nr_of_orders
from orders
where delivery_city like "C%"
group by 1
order by 2 desc

/* 3B. Liczba zamówień dla wybranych miast: "Houston, Philadelphia"/ Number of orders for cities: "Houston, Philadelphia" */
select
	delivery_city
	,count(order_id) as nr_of_orders
from orders
where delivery_city in ("Houston", "Philadelphia")
group by 1
order by 2 desc

 /* 3C. Procentowy udział zamówień z danego kraju/ Percentage of orders by country */
select
	delivery_city
	,count(order_id) as nr_of_orders
	,round((count(order_id)/(select count(order_id) from orders))*100,2) as percentage_of_orders
from orders
group by 1
order by 2 desc

/*4. Miasta z największą liczbą zamówień/ Cities with the highest number of orders */
select
	delivery_city
	,count(order_id) as nr_of_orders
from orders
group by 1
order by 2 desc
limit 5

/* 6. Liczba zamówień w każdym miesiącu/ Number of orders per month */
select
	year(order_date) 	as order_year
	,month(order_date) 	as order_month
	,count(*) 		as nr_of_orders
from orders
group by 1,2
order by 1,2

/* 7. Klienci z największą liczbą zamówień/ Customers with the highest number of orders (top 10) */
select
	customer_id
	,count(order_id) as nr_of_orders
from orders
group by 1
order by 2 desc
limit 10

/*8.  Liczba zamówień zrealizowanych tego samego dnia w podziale na rok i miesiąc/ Number of orders shipped on the same day */

select
	year(order_date) as year_of_order
	,month(order_date) as month_of_order
	,count(order_id) as nr_of_orders
from orders
where shipping_date = order_date
group by 1,2
order by 1,2

/*  Procent zamówień wysłanych tego samego dnia względem wszystkich zamówień/ Percentage of orders shipped on the same day relative to all orders */
with total_orders as
	(
	select count(order_id) as total
	from orders
	) 
select 
	count(o.order_id) as nr_of_orders
	,tor.total as total
	,round((count(o.order_id)/tor.total)*100,2) as percentage
from total_orders tor
cross join orders o
where shipping_date=order_date
group by tor.total

/* 9. Zamówienia per klient - histogram/ Orders per customer – histogram */
with
orders_per_customer as
	(
	select 
		customer_id
		,count(order_id) as orders
	from orders
	group by 1
	)
select 
	orders
	,count(customer_id) as num_of_customers
	,round(count(customer_id)/(select count(distinct customer_id) from orders)*100,2) as percent_of_customers
from orders_per_customer
group by 1
order by 1

/* 10. Średni czas dostawy dla każdego kraju/ Average delivery time per country */
select
delivery_city
,round(avg(datediff(shipping_date, order_date))) as avg_delivery
from orders
group by 1
order by 2
