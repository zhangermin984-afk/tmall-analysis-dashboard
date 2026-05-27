SELECT
    province,
    COUNT(DISTINCT order_id) AS total_order_cnt,
    COUNT(DISTINCT CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN order_id END) AS paid_order_cnt,
    COUNT(DISTINCT CASE WHEN refund_amount > 0 THEN order_id END) AS refund_order_cnt,
    ROUND(SUM(total_amount), 2) AS total_gmv,
    ROUND(SUM(pay_amount), 2) AS paid_amount,
    ROUND(SUM(refund_amount), 2) AS refund_amount,
    ROUND(SUM(pay_amount) - SUM(refund_amount), 2) AS net_paid_amount,
    ROUND(AVG(CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN pay_amount END), 2) AS avg_order_value,
    ROUND(
        COUNT(DISTINCT CASE WHEN refund_amount > 0 THEN order_id END) * 1.0
        / COUNT(DISTINCT order_id),
        4
    ) AS refund_order_rate
FROM clean_orders
GROUP BY province
ORDER BY paid_amount DESC;