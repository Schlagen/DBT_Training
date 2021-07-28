with payments as (

    select * from {{ ref('stg_payments')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

order_paymets as (
    select
        order_id,
        sum(case when status = 'success' then amount end) as amount

    from payments
    group by 1

),

final as (

    select 
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_paymets.amount, 0) as amount

    from orders
    left join order_paymets using (order_id)
)

select * from final