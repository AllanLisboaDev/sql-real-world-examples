CREATE FUNCTION dbo.fn_calculate_net_amount
(
    @GrossAmount DECIMAL(18,2),
    @Discount    DECIMAL(18,2),
    @TaxRate     DECIMAL(5,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    /*
        This function calculates the net amount based on:
        - Gross amount
        - Discount
        - Tax rate percentage
    */

    DECLARE @NetAmount DECIMAL(18,2);

    -- Basic validation
    IF (@GrossAmount IS NULL OR @GrossAmount < 0)
        RETURN 0;

    IF (@Discount IS NULL OR @Discount < 0)
        SET @Discount = 0;

    IF (@TaxRate IS NULL OR @TaxRate < 0)
        SET @TaxRate = 0;

    SET @NetAmount =
        (@GrossAmount - @Discount) * (1 - (@TaxRate / 100));

    RETURN @NetAmount;
END;
GO
