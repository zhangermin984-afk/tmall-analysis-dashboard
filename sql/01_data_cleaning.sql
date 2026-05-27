CREATE OR REPLACE TABLE clean_orders AS
SELECT
    TRY_CAST("订单编号" AS BIGINT) AS order_id,
    TRY_CAST("总金额" AS DOUBLE) AS total_amount,
    TRY_CAST("买家实际支付金额" AS DOUBLE) AS pay_amount,
    "收货地址" AS province,
    TRY_CAST("订单创建时间" AS TIMESTAMP) AS order_create_time,
    TRY_CAST("订单付款时间" AS TIMESTAMP) AS pay_time,
    TRY_CAST("退款金额" AS DOUBLE) AS refund_amount,
    TRY_CAST("订单创建时间" AS DATE) AS order_date,

    CASE
        WHEN TRY_CAST("退款金额" AS DOUBLE) > 0 THEN '退款订单'
        WHEN "订单付款时间" IS NULL 
             OR TRY_CAST("买家实际支付金额" AS DOUBLE) = 0 THEN '未支付订单'
        ELSE '已支付订单'
    END AS order_status

FROM raw_orders
WHERE "订单编号" IS NOT NULL;