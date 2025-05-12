

# Quantum Supply Sales Analysis

## About Quantum Supply

Quantum Supply is a leading e-commerce platform specializing in high-quality tech products and gadgets. Since launching in 2018, it has become a top choice for tech enthusiasts, offering a carefully selected range of premium electronics—including gaming monitors, headphones, and laptops—from brands like Apple, Samsung, and Bose. With global shipping, competitive pricing, and a constantly refreshed lineup of new products and loyalty program offers, Quantum Supply delivers an exceptional shopping experience for tech lovers everywhere.

### Dataset
The dataset contains detailed records of sales transactions from 2019 to 2022 including the user id, product, purchase date, region, country, currency, and purchase platform. 

The full ERD of the sales dataset can be found [here.](https://github.com/user-attachments/assets/5f9ee2a7-9383-4618-80ba-45ff34bc1bb1)

Cleaning of the dataset was required before analysis, you can view a change log here(link). 

# Sales Performance Summary
![Overall Trends](https://i.imgur.com/iTUMC6J.png)

### Overall Trends
- From 2019-2022, the company generated **$28M** from **108k total orders**, 2019 saw the lowest annual revenue at $3.8M with a peak annual revenue reaching **$10M** in 2020.

- Annually the largest sales growth occurred between 2019 and 2020 at **163% (YoY)** , while 2021 to 2022 experiencing a **46% decline** in sales year over year.

### Best-Selling Product/Region
- **North America**, particularly the U.S., accounted for over **50% of revenue**, with **$14M in sales** from **50k orders**.
- The **27-inch 4K Gaming Monitor**, **Apple AirPods**, **MacBook Air**, and **Thinkpad Laptop** contributing **96%** of total sales, amounting to **$27M** combined.

### Loyalty Program
- By 2022, spending by loyalty and non-loyalty members reached equilibrium, but **non-loyalty members spending declined**.
- **Loyalty members** showed consistent growth in **Average Order Value (AOV)**, surpassing non-loyalty members by 2021.

### Refund Rates
- The overall **refund rate** across all transactions is **6%**.
- The **MacBook Air** had the highest refund rate at **11%**, followed by the **Apple iPhone** at **8%**, and the **Apple AirPods** at **5%**.


# Deep Dive Insights

## Sales Trends

#### Monthly Figures
- **September** and **December** saw the highest number of sales (**$2.7M and $2.8M**) with **February** and **October** generating the lowest sales (**$1.9M each**). 

- Sales and order count growth were aligned, with the highest month over month increase occurring in **March 2020** at **50%** and the steepest decline in **October 2022** at **-55%**. 
 
 - When looking in aggregate by month from 2019-2022, we saw that our
   highest sales occurred in January, September, and December at a peak
   of **$1.2M sales in December of 2020**.  
  
  - The lowest sales occurring in February and October at a
   **low of $178k in sales October of 2022**. 
 
 - A majority of sales are coming from **North America accounting for $14M
   in total revenue**, with Europe, Middle East, and Africa accounting for
   $8M, combined show for over 80% of the total revenue.

## Product Trends

![enter image description here](https://i.imgur.com/0cnXp91.png)

- When looking into product sales, the best performing products are the 27In Gaming Monitor, Apple Airpods, Macbook Air, and ThinkPad Laptop accounting for **96% of all sales.** 

- By brand, **Apple is responsible for more than half of all sales**, with Airpods generating $8M and the Macbook $6M. 
- In 2020, the Macbook Air drove a significant spike in revenue, with its share of revenue increasing by 84% from 2019, **generating an additional $2.3 million in sales**, including 255 orders in Q2 alone, totaling $392,260 with an average order value of $1,538.
-  While the top-performing 27in 4K Gaming Monitor **experienced a 19% decrease** in its percentage of total sales for that year.
- From 2019-2022 the quarterly average of 98 Macbooks sold and generating an average quarterly sales of $155k. (Question 1)
- **Apple AirPods emerged as the most popular product across all regions**, with the highest total orders in North America (18,574), EMEA (11,227), and Unknown (12,466). Notably, the LATAM  and APAC (4,226) region recorded the lowest orders at 1,911, indicating variability in product popularity across different markets.

## Loyalty Program
- The loyalty program launched in 2019 with a slow rate of adoption where Non-Loyalty members outspent Loyalty Members during the first two years of the program. However in 2021, Loyalty Members began to outspend Non-Loyalty Members by over $500,000 as well as reaching a **steady AOV of $245 versus $214 for Non-Loyalty Members.**

- Initially only 11% of all orders were made by Loyalty Members, however by 2021, **over half of all orders were placed by members of the loyalty program.**
- **Loyalty members on average took 49 days to purchase** an item after creating their account, 30% quicker than Non-loyalty members that took 70 days to purchase. 

| loyalty_program | days_to_purchase | months_to_purchase |
|-----------------|------------------|--------------------|
| 0               | 70.5             | 2.3                |
| 1               | 49.3             | 1.6                |

## Refund Rates
- The overall refund rate is 5.91% which is much lower than the industry average of 17% for ecommerce brands according to [Shopify Ecommerce Returns Data.](https://www.shopify.com/enterprise/blog/ecommerce-returns "Shopify Return Data")

- When looking further into Apple product returns, the Macbook Air had the 2nd highest return rate of 11.43% more than double the return rate of the Airpods at just 5.45%.

### Product Refund Rates
| Row |  product_name               |  orders_placed  |  refunds  |  refund_rate  |
|-----|-----------------------------|-----------------|-----------|---------------|
|   1 | ThinkPad Laptop             |            2916 |       342 |        0.1173 |
|   2 | Macbook Air Laptop          |            3964 |       453 |        0.1143 |
|   3 | Apple iPhone                |             288 |        22 |        0.0764 |
|   4 | 27in 4K gaming monitor      |           23408 |      1444 |        0.0617 |
|   5 | Apple AirPods Headphones    |           48404 |      2636 |        0.0545 |
|   6 | Samsung Webcam              |            7197 |       186 |        0.0258 |
|   7 | Samsung Charging Cable Pack |           21923 |       294 |        0.0134 |
|   8 | bose soundsport headphones  |              27 |         0 |           0.0 |


### Supplier Refund Rates
| Row |  supplier            |  orders_placed  |  refunds  |  refund_rate  |
|-----|----------------------|-----------------|-----------|---------------|
|   1 | Circuitworks         |           28949 |      1645 |        0.0568 |
|   2 | Novatech             |           66397 |      3248 |        0.0489 |
|   3 | Electronics Emporium |            6906 |       269 |         0.039 |
|   4 | Zenith               |            5875 |       215 |        0.0366 |

- Circuitworks had the highest refund rate of 5.68% over 28k orders, versus Novatech which had a refund rate of 4.89% over 66k orders.

*2022 did not have any recorded returns indicating there may have been an issue when gathering the data.*

## Recommendations


**1. Advertising & Customer Re-engagement**

-   _Target past high-value customers:_  Since sales peaked in 2020 and 2021, approximately  **$13.8M**  (from a total of  **$28M**) was generated during these years—focusing retargeting efforts on this segment could capitalize on their demonstrated purchase behavior.
-   _Estimated impact:_  Re-engaging even  **10%**  of these past customers—roughly  **1,380 customers**—who have previously purchased high-margin items like Macbooks and AirPods, could potentially recapture  **$200K+**  in revenue, assuming an average repeat order of  **$150**.

----------

**2. Refund Analysis & Quality Control Enhancement**

-   _Address high refund rates:_  The Macbook Air has an  **11.43% refund rate**  over 3,964 orders (~**453 refunds**).
-   _Potential savings:_  Reducing the Macbook Air refund rate by just  **2%**  could prevent  **~80 refunds**, saving approximately  **$130K**  in loss, based on an average order value of  **$538**.
-   _Actionable step:_  Focus quality assessment and customer feedback on return reasons for Macbooks, possibly lowering its refund rate closer to the AirPods'  **5.45%**.

----------

**3. Promotion Strategies & Sales Volume Growth**

-   _Leverage product-specific demand surges:_  During peak months (e.g., December with  **$2.8M sales**, 2020), offering targeted discounts of  **15-20%**  on flagship products like the 27-inch Gaming Monitor could significantly increase sales volume.
-   _Expected outcome:_  If a  **20% discount**  on a high-demand product priced at  **$400**  leads to a  **30% volume increase**  (e.g., from 100 to 130 units sold), total revenue could rise from  **$40K**  to  **$52K**, compensating for the initial margin reduction.

----------

**4. Product Expansion & Category Diversification**

-   _Capitalize on top categories:_  The Gaming Monitor, AirPods, MacBook Air, and ThinkPad collectively generate about  **$27M**, representing  **96% of total sales**.
-   _Opportunity:_  Adding complementary accessories (keyboards, mice, headsets) could boost category sales by  **10-15%**, translating to an additional  **$2.7M-$4M**  over time, especially effective during demand surges when customers are more receptive to bundling.

----------

**5. Regional Growth Initiatives**

-   _Focus on expanding in APAC and LATAM:_  Currently, LATAM and APAC regions account for roughly  **7%**  of total revenue (~**$1.96M**  from about  **4,137 orders**).
-   _Potential:_  Tailored region-specific marketing or localized product offerings could increase regional sales growth by  **20-30%**  over the next year, translating to an additional  **$0.4M-$0.6M**.
