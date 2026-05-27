-- 1. 整体核心指标
SELECT
    COUNT(DISTINCT order_id) AS total_order_cnt,
    COUNT(DISTINCT CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN order_id END) AS paid_order_cnt,
    COUNT(DISTINCT CASE WHEN refund_amount > 0 THEN order_id END) AS refund_order_cnt,
    ROUND(SUM(total_amount), 2) AS total_gmv,
    ROUND(SUM(pay_amount), 2) AS paid_amount,
    ROUND(SUM(refund_amount), 2) AS refund_amount,
    ROUND(SUM(pay_amount) - SUM(refund_amount), 2) AS net_paid_amount,
    ROUND(AVG(CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN pay_amount END), 2) AS avg_order_value
FROM clean_orders;


-- 2. 每日经营指标趋势
SELECT
    order_date,
    COUNT(DISTINCT order_id) AS total_order_cnt,
    COUNT(DISTINCT CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN order_id END) AS paid_order_cnt,
    COUNT(DISTINCT CASE WHEN refund_amount > 0 THEN order_id END) AS refund_order_cnt,
    ROUND(SUM(pay_amount), 2) AS paid_amount,
    ROUND(SUM(refund_amount), 2) AS refund_amount,
    ROUND(SUM(pay_amount) - SUM(refund_amount), 2) AS net_paid_amount,
    ROUND(AVG(CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN pay_amount END), 2) AS avg_order_value
FROM clean_orders
GROUP BY order_date
ORDER BY order_date;


-- 3. 订单状态分布
SELECT
    order_status,
    COUNT(DISTINCT order_id) AS order_cnt,
    ROUND(SUM(total_amount), 2) AS total_gmv,
    ROUND(SUM(pay_amount), 2) AS paid_amount,
    ROUND(SUM(refund_amount), 2) AS refund_amount
FROM clean_orders
GROUP BY order_status
ORDER BY order_cnt DESC;