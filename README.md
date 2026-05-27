# 天猫电商订单数据分析与 Tableau 经营看板搭建

 1. 项目背景
本项目基于 2.8 万条天猫订单数据，围绕平台经营表现、地区销售结构、订单状态和销售异动情况进行分析，完成从数据清洗、SQL 指标计算、结果表导出到 Tableau 看板搭建的完整数据分析流程。

 2. 使用工具
- Python / Pandas
- DuckDB SQL
- Tableau
- Excel

 3. 分析内容
1. 数据清洗与订单状态标签构建  
2. 核心经营指标计算：支付金额、净支付金额、订单量、支付订单数、客单价、退款率  
3. 地区销售与退款分析：支付金额 Top10、订单量 Top10、退款金额 Top10、退款率 Top10  
4. 销售异动分析：基于 LAG() 窗口函数计算每日支付金额、订单量和退款金额变化额，并识别异常波动日期  
5. Tableau 看板搭建：经营总览、地区销售与退款分析、销售异动分析三页看板  

4. 项目结构
```text
tmall-analysis-dashboard/
├── data/processed/        # 清洗后数据与分析结果表
├── sql/                   # SQL 清洗与分析脚本
├── notebook/              # Python 数据处理 Notebook
├── dashboard/             # Tableau 看板文件与截图
└── README.md
