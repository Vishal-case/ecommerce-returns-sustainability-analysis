use mydb;
SET SQL_SAFE_UPDATES = 0;

-- 	Total number of orders
--	Total order value
--	Number of returned orders
--	Return rate
--	Total return cost
--	Total profit/loss
--	Average order value
--	Average days to return

select * from returns_sustainability_dataset;

SELECT
    COUNT(DISTINCT Order_ID) AS total_orders,
	SUM(Order_Value) AS total_order_value,
	COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned'
        THEN Order_ID
    END) AS returned_orders,
	ROUND(
        COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned'
            THEN Order_ID
        END) * 100.0
        / COUNT(DISTINCT Order_ID),
        2
    ) AS return_rate_percentage,
	SUM(
        CASE
            WHEN Return_Status = 'Returned'
            THEN Return_Cost
            ELSE 0
        END
    ) AS total_return_cost,
	SUM(Profit_Loss) AS total_profit_loss,
	ROUND(
        SUM(Order_Value) / COUNT(DISTINCT Order_ID),
        2
    ) AS average_order_value,
	ROUND(
        AVG(
            CASE
                WHEN Return_Status = 'Returned'
                THEN Days_to_Return
            END
        ),
        2
    ) AS average_days_to_return
FROM returns_sustainability_dataset;

-- Number of returns by reason
-- Percentage of total returns for each reason
-- Return cost by reason
-- Profit/loss by reason
-- Average days to return by reason

select
     Return_Reason,
     count(distinct Order_Id) as number_of_returns,
     round(
     count(distinct order_id) * 100 /
     sum(count(distinct order_id)) over(),
     2
     ) as Percentage_total_returns,
     SUM(Return_Cost) AS total_return_cost,
	SUM(Profit_Loss) AS total_profit_loss,
    round(
    avg( days_to_return),
    2
    ) as Average_days_to_return
    from returns_sustainability_dataset
    WHERE Return_Status = 'Returned' AND Return_Reason IS NOT NULL
GROUP BY Return_Reason
ORDER BY number_of_returns DESC;

-- Product Category Analysis
--	Total orders
--	Total sales/order value
--	Returned orders
--	Return rate
--	Total return cost
--	Total profit/loss
--	Average order value
--	Average days to return

SELECT
    Product_Category,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Order_Value) AS Total_Sales_Order_Value,
    COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned' THEN Order_ID
    END) AS Returned_Orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END) / COUNT(DISTINCT Order_ID),
        2
    ) AS Return_Rate,
    SUM(Return_Cost) AS Total_Return_Cost,
    SUM(Profit_Loss) AS Total_Profit_Loss,
    ROUND(AVG(Order_Value), 2) AS Average_Order_Value,
    ROUND(AVG(CASE
        WHEN Return_Status = 'Returned' THEN Days_to_Return
    END), 2) AS Average_Days_to_Return
FROM returns_sustainability_dataset
GROUP BY Product_Category
ORDER BY Total_Orders DESC;

-- Product-Level Analysis
-- Top 10 products with the highest return rate
-- Top 10 products with the highest number of returns
-- Top 10 products generating the largest profit/loss
-- Top 10 products generating the highest return cost

WITH product_metrics AS (
    SELECT
        Product_ID,
        COUNT(DISTINCT Order_ID) AS Total_Orders,

        COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END) AS Returned_Orders,

        SUM(Profit_Loss) AS Total_Profit_Loss,

        SUM(CASE
            WHEN Return_Status = 'Returned' THEN Return_Cost
            ELSE 0
        END) AS Total_Return_Cost

    FROM returns_sustainability_dataset
    GROUP BY Product_ID
)

SELECT
    Product_ID,
    Total_Orders,
    Returned_Orders,
    ROUND(
        100.0 * Returned_Orders / NULLIF(Total_Orders, 0),
        2
    ) AS Return_Rate,
    Total_Profit_Loss,
    Total_Return_Cost
FROM product_metrics
ORDER BY Total_Orders DESC;

-- Customer Analysis
-- Customers with the highest number of orders
-- Customers with the highest number of returns
-- Customers with the highest return rate
-- Customers generating the highest total order value
-- Customers generating the largest losses

WITH customer_metrics AS (
    SELECT
        User_ID,

        COUNT(DISTINCT Order_ID) AS Total_Orders,

        COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END) AS Returned_Orders,

        SUM(Order_Value) AS Total_Order_Value,

        SUM(Profit_Loss) AS Total_Profit_Loss

    FROM returns_sustainability_dataset
    GROUP BY User_ID
)

SELECT
    User_ID,
    Total_Orders,
    Returned_Orders,
    ROUND(
        100.0 * Returned_Orders / NULLIF(Total_Orders, 0),
        2
    ) AS Return_Rate,
    Total_Order_Value,
    Total_Profit_Loss
FROM customer_metrics
ORDER BY Total_Order_Value DESC;

-- Age Group Analysis
-- Total customers/orders
-- Return rate
-- Average order value
-- Average days to return
-- Total return cost
-- Total profit/loss

WITH age_group_data AS (
    SELECT
        User_ID,
        Order_ID,
        User_Age,
        Order_Value,
        Return_Status,
        Days_to_Return,
        Return_Cost,
        Profit_Loss,

        CASE
            WHEN User_Age BETWEEN 18 AND 25 THEN '18–25'
            WHEN User_Age BETWEEN 26 AND 35 THEN '26–35'
            WHEN User_Age BETWEEN 36 AND 45 THEN '36–45'
            WHEN User_Age BETWEEN 46 AND 55 THEN '46–55'
            WHEN User_Age >= 56 THEN '56+'
            ELSE 'Other'
        END AS Age_Group

    FROM returns_sustainability_dataset
)

SELECT
    Age_Group,

    COUNT(DISTINCT User_ID) AS Total_Customers,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned' THEN Order_ID
    END) AS Returned_Orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    ROUND(AVG(Order_Value), 2) AS Average_Order_Value,

    ROUND(
        AVG(CASE
            WHEN Return_Status = 'Returned' THEN Days_to_Return
        END),
        2
    ) AS Average_Days_to_Return,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    ROUND(SUM(Profit_Loss), 2) AS Total_Profit_Loss

FROM age_group_data

GROUP BY Age_Group

ORDER BY
    CASE Age_Group
        WHEN '18–25' THEN 1
        WHEN '26–35' THEN 2
        WHEN '36–45' THEN 3
        WHEN '46–55' THEN 4
        WHEN '56+' THEN 5
        ELSE 6
    END;
    
-- Gender Analysis
-- Number of orders
-- Number of returns
-- Return rate
-- Average order value
-- Average return cost
-- Profit/loss

SELECT
    User_Gender,

    COUNT(DISTINCT Order_ID) AS Number_of_Orders,

    COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned' THEN Order_ID
    END) AS Number_of_Returns,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    ROUND(
        AVG(Order_Value),
        2
    ) AS Average_Order_Value,

    ROUND(
        AVG(CASE
            WHEN Return_Status = 'Returned' THEN Return_Cost
        END),
        2
    ) AS Average_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss
FROM returns_sustainability_dataset
GROUP BY User_Gender
ORDER BY Return_Rate DESC;

-- Location Analysis
-- Locations with the highest number of orders
-- Locations with the highest return rate
-- Locations with the highest return cost
-- Locations with the largest profit/loss
-- Locations with the highest CO₂ emissions
-- Locations with the highest packaging waste

SELECT
    User_Location,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned' THEN Order_ID
    END) AS Returned_Orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    SUM(Profit_Loss) AS Total_Profit_Loss,

    SUM(CO2_Emissions) AS Total_CO2_Emissions,

    SUM(Packaging_Waste) AS Total_Packaging_Waste
FROM returns_sustainability_dataset
GROUP BY User_Location
ORDER BY Total_Orders DESC;

-- Shipping Method Analysis
-- Number of orders
-- Return rate
-- Average order value
-- Total return cost
-- Profit/loss
-- CO₂ emissions
-- Packaging waste

SELECT
    Shipping_Method,
	COUNT(DISTINCT Order_ID) AS Number_of_Orders,
	ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    ROUND(
        AVG(Order_Value),
        2
    ) AS Average_Order_Value,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss,

    ROUND(
        SUM(CO2_Emissions),
        2
    ) AS CO2_Emissions,

    ROUND(
        SUM(Packaging_Waste),
        2
    ) AS Packaging_Waste
FROM returns_sustainability_dataset
GROUP BY Shipping_Method
ORDER BY Number_of_Orders DESC;

-- Payment Method Analysis
-- Orders
-- Return rate
-- Order value
-- Return cost
-- Profit/loss

SELECT
    Payment_Method,

    COUNT(DISTINCT Order_ID) AS Number_of_Orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    ROUND(
        SUM(Order_Value),
        2
    ) AS Total_Order_Value,

    ROUND(
        AVG(Order_Value),
        2
    ) AS Average_Order_Value,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss
FROM returns_sustainability_dataset
GROUP BY Payment_Method
ORDER BY Number_of_Orders DESC;

-- Discount Analysis
-- Number of orders
-- Average order value
-- Return rate
-- Return cost
-- Profit/loss

WITH discount_data AS (
    SELECT
        Order_ID,
        Discount_Applied,
        Order_Value,
        Return_Status,
        Return_Cost,
        Profit_Loss,

        CASE
            WHEN Discount_Applied = 0 THEN '0% discount'
            WHEN Discount_Applied > 0
                 AND Discount_Applied <= 10 THEN '1–10%'
            WHEN Discount_Applied > 10
                 AND Discount_Applied <= 20 THEN '11–20%'
            WHEN Discount_Applied > 20
                 AND Discount_Applied <= 30 THEN '21–30%'
            WHEN Discount_Applied > 30 THEN '30%+'
            ELSE 'Other'
        END AS Discount_Group

    FROM returns_sustainability_dataset
)

SELECT
    Discount_Group,

    COUNT(DISTINCT Order_ID) AS Number_of_Orders,

    ROUND(
        AVG(Order_Value),
        2
    ) AS Average_Order_Value,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss

FROM discount_data

GROUP BY Discount_Group

ORDER BY
    CASE Discount_Group
        WHEN '0% discount' THEN 1
        WHEN '1–10%' THEN 2
        WHEN '11–20%' THEN 3
        WHEN '21–30%' THEN 4
        WHEN '30%+' THEN 5
        ELSE 6
    END;
    
-- Return Timing Analysis
-- Analyze Days_to_Return
-- Number of returns
-- Percentage of returns
-- Return cost
-- Profit/loss

WITH return_data AS (
    SELECT
        Order_ID,
        Days_to_Return,
        Return_Cost,
        Profit_Loss,

        CASE
            WHEN Days_to_Return BETWEEN 0 AND 7 THEN '0–7 days'
            WHEN Days_to_Return BETWEEN 8 AND 14 THEN '8–14 days'
            WHEN Days_to_Return BETWEEN 15 AND 30 THEN '15–30 days'
            WHEN Days_to_Return BETWEEN 31 AND 60 THEN '31–60 days'
            WHEN Days_to_Return > 60 THEN '60+ days'
            ELSE 'Other'
        END AS Return_Time_Bucket

    FROM returns_sustainability_dataset
    WHERE Return_Status = 'Returned'
)

SELECT
    Return_Time_Bucket,

    COUNT(DISTINCT Order_ID) AS Number_of_Returns,

    ROUND(
        100.0 * COUNT(DISTINCT Order_ID)
        / NULLIF(
            (SELECT COUNT(DISTINCT Order_ID)
             FROM returns_sustainability_dataset
             WHERE Return_Status = 'Returned'),
            0
        ),
        2
    ) AS Percentage_of_Returns,

    SUM(Return_Cost) AS Total_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss

FROM return_data

GROUP BY Return_Time_Bucket

ORDER BY
    CASE Return_Time_Bucket
        WHEN '0–7 days' THEN 1
        WHEN '8–14 days' THEN 2
        WHEN '15–30 days' THEN 3
        WHEN '31–60 days' THEN 4
        WHEN '60+ days' THEN 5
        ELSE 6
    END;

-- Sustainability Analysis
-- Average CO₂ emissions
-- Total CO₂ emissions
-- Average packaging waste
-- Total packaging waste
-- Average CO₂ saved
-- Total CO₂ saved
-- Average waste avoided
-- Total waste avoided

SELECT
    CASE
        WHEN Return_Status = 'Returned' THEN 'Returned'
        ELSE 'Non-Returned'
    END AS Order_Status,

    COUNT(DISTINCT Order_ID) AS Number_of_Orders,

    ROUND(AVG(CO2_Emissions), 2) AS Average_CO2_Emissions,
    ROUND(SUM(CO2_Emissions), 2) AS Total_CO2_Emissions,

    ROUND(AVG(Packaging_Waste), 2) AS Average_Packaging_Waste,
    ROUND(SUM(Packaging_Waste), 2) AS Total_Packaging_Waste,

    ROUND(AVG(CO2_Saved), 2) AS Average_CO2_Saved,
    ROUND(SUM(CO2_Saved), 2) AS Total_CO2_Saved,

    ROUND(AVG(Waste_Avoided), 2) AS Average_Waste_Avoided,
    ROUND(SUM(Waste_Avoided), 2) AS Total_Waste_Avoided

FROM returns_sustainability_dataset

GROUP BY
    CASE
        WHEN Return_Status = 'Returned' THEN 'Returned'
        ELSE 'Non-Returned'
    END

ORDER BY
    CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 2
    END;
    
    -- Return + Sustainability Relationship
-- Category	Return Rate	Return Cost	Profit/Loss	CO₂	Packaging Waste
 

SELECT
    Product_Category,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned' THEN Order_ID
    END) AS Returned_Orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss,

    ROUND(
        SUM(CO2_Emissions),
        2
    ) AS Total_CO2_Emissions,

    ROUND(
        SUM(Packaging_Waste),
        2
    ) AS Total_Packaging_Waste

FROM returns_sustainability_dataset

GROUP BY Product_Category

ORDER BY Return_Rate DESC;

-- Monthly Return Trend
-- Total orders
-- Total order value
-- Returned orders
-- Return rate
-- Return cost
-- Profit/loss
-- CO₂ emissions
-- Packaging waste

SELECT
    DATE_FORMAT(STR_TO_DATE(Order_Date, '%Y-%m-%d'), '%Y-%m') AS Month,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    ROUND(
        SUM(Order_Value),
        2
    ) AS Total_Order_Value,

    COUNT(DISTINCT CASE
        WHEN Return_Status = 'Returned' THEN Order_ID
    END) AS Returned_Orders,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN Return_Status = 'Returned' THEN Order_ID
        END)
        / NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Return_Rate,

    SUM(CASE
        WHEN Return_Status = 'Returned' THEN Return_Cost
        ELSE 0
    END) AS Total_Return_Cost,

    ROUND(
        SUM(Profit_Loss),
        2
    ) AS Profit_Loss,

    ROUND(
        SUM(CO2_Emissions),
        2
    ) AS CO2_Emissions,

    ROUND(
        SUM(Packaging_Waste),
        2
    ) AS Packaging_Waste

FROM returns_sustainability_dataset

GROUP BY
    DATE_FORMAT(STR_TO_DATE(Order_Date, '%Y-%m-%d'), '%Y-%m')

ORDER BY
    Month ASC;
























    
