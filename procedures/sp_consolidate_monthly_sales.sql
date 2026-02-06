CREATE PROCEDURE dbo.sp_consolidate_monthly_sales
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    SET NOCOUNT ON;

    /*
        This procedure consolidates monthly sales data per customer.
        It filters invalid records, applies basic business rules
        and returns aggregated values for reporting purposes.
    */

    -- Validate date range
    IF (@StartDate IS NULL OR @EndDate IS NULL OR @StartDate > @EndDate)
    BEGIN
        RAISERROR ('Invalid date range.', 16, 1);
        RETURN;
    END;

    -- Consolidate sales data
    SELECT
        c.CustomerId,
        c.CustomerName,
        YEAR(o.OrderDate)  AS SalesYear,
        MONTH(o.OrderDate) AS SalesMonth,
        COUNT(o.OrderId)   AS TotalOrders,
        SUM(o.TotalAmount) AS TotalSalesAmount
    FROM Orders o
    INNER JOIN Customers c
        ON c.CustomerId = o.CustomerId
    WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
      AND o.Status = 'COMPLETED'
      AND o.TotalAmount > 0
    GROUP BY
        c.CustomerId,
        c.CustomerName,
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
    ORDER BY
        SalesYear,
        SalesMonth,
        TotalSalesAmount DESC;
END;
GO
