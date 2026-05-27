WITH daily AS (
    SELECT
        order_date,
        COUNT(DISTINCT order_id) AS total_order_cnt,
        COUNT(DISTINCT CASE WHEN pay_time IS NOT NULL AND pay_amount > 0 THEN order_id END) AS paid_order_cnt,
        COUNT(DISTINCT CASE WHEN refund_amount > 0 THEN order_id END) AS refund_order_cnt,
        ROUND(SUM(pay_amount), 2) AS paid_amount,
        ROUND(SUM(refund_amount), 2) AS refund_amount,
        ROUND(SUM(pay_amount) - SUM(refund_amount), 2) AS net_paid_amount
    FROM clean_orders
    GROUP BY order_date
),

daily_with_lag AS (
    SELECT
        *,
        LAG(paid_amount) OVER (ORDER BY order_date) AS last_day_paid_amount,
        LAG(total_order_cnt) OVER (ORDER BY order_date) AS last_day_order_cnt,
        LAG(refund_amount) OVER (ORDER BY order_date) AS last_day_refund_amount
    FROM daily
),

daily_calc AS (
    SELECT
        order_date,
        total_order_cnt,
        paid_order_cnt,
        refund_order_cnt,
        paid_amount,
        refund_amount,
        net_paid_amount,

        last_day_paid_amount,
        last_day_order_cnt,
        last_day_refund_amount,

        ROUND(paid_amount - last_day_paid_amount, 2) AS paid_amount_diff,
        total_order_cnt - last_day_order_cnt AS order_cnt_diff,
        ROUND(refund_amount - last_day_refund_amount, 2) AS refund_amount_diff,

        CASE
            WHEN last_day_paid_amount IS NULL OR last_day_paid_amount < 1000 THEN NULL
            ELSE ROUND((paid_amount - last_day_paid_amount) / last_day_paid_amount, 4)
        END AS paid_amount_growth_rate,

        CASE
            WHEN last_day_order_cnt IS NULL OR last_day_order_cnt < 50 THEN NULL
            ELSE ROUND((total_order_cnt - last_day_order_cnt) * 1.0 / last_day_order_cnt, 4)
        END AS order_cnt_growth_rate,

        CASE
            WHEN last_day_refund_amount IS NULL OR last_day_refund_amount < 1000 THEN NULL
            ELSE ROUND((refund_amount - last_day_refund_amount) / last_day_refund_amount, 4)
        END AS refund_amount_growth_rate

    FROM daily_with_lag
)

SELECT
    *,
    CASE
        WHEN paid_amount_growth_rate >= 0.3 AND paid_amount_diff >= 10000 THEN '销售额明显上涨'
        WHEN paid_amount_growth_rate <= -0.3 AND paid_amount_diff <= -10000 THEN '销售额明显下跌'
        WHEN refund_amount_growth_rate >= 0.3 AND refund_amount_diff >= 5000 THEN '退款金额明显上涨'
        ELSE '正常波动'
    END AS abnormal_type

FROM daily_calc
ORDER BY order_date;