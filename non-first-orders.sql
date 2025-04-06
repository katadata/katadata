/* which products generated the most non-first orders */
with 
order_ranking as
	(
	select
		order_id
		,customer_id 
		,row_number() over (partition by customer_id order by order_id) as ranked_order
	from orders
	),
orders_made as
	(
	select
		o.order_id
		,o.customer_id
		,op.product_id
		,op.order_position_id
		,ora.ranked_order
		,max(ora.ranked_order) over (partition by customer_id)-1 as non_first_order_made
	from orders o
	join order_positions op on o.order_id = op.order_id
	join order_ranking 	ora	on o.order_id = ora.order_id
	order by 2, 1
	),
prep_agg as 
(
select distinct
	order_id
	,product_id
	,non_first_order_made
from orders_made
where ranked_order = 1
)
select
	product_id
	,sum(non_first_order_made) as all_non_first_orders_made
from prep_agg
group by 1
order by 2 desc
limit 1


