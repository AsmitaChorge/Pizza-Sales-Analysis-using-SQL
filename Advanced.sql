
--  1. Calculate the percentage contribution of each pizza type to total revenue.
-- generated revenue by each pizza type / total sales * 100

select pizza_types.category, round(sum(order_details.quantity * pizzas.price)/ (select 
round(sum(order_details.quantity * pizzas.price), 2) as total_sales
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id) * 100,2 )  as revenue

from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;


-- 2.Analyze the cumulative revenue(CR) generated over time.

--  d1 R 300 >> CR 300
--  d2 R 400 >> CR 700
--  d3 R 300 >> CR 1000
-- sum of revenue based on dates

select date, 
sum(revenue) over (order by date) as cum_revenue
from
(select orders.date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.date) as sales;



--  3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
 
 select name, revenue
 from
 
 (select category, name, revenue,
 rank() over(partition by category order by revenue desc) as rn
 from
 
 (select pizza_types.category, pizza_types.name,
 sum(order_details.quantity * pizzas.price) as revenue
 from pizza_types join pizzas
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.category, pizza_types.name) 
 as A)
 
 as B
where rn <= 3 ;









