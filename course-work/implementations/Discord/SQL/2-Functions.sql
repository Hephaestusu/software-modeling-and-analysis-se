USE Discord;
GO

IF OBJECT_ID('dbo.fn_UserLastActivity', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_UserLastActivity;
GO

CREATE FUNCTION dbo.fn_UserLastActivity
(
    @UserID INT
)
RETURNS DATETIME2
AS
BEGIN
    DECLARE @LastActivity DATETIME2;

    SELECT @LastActivity = MAX(sent_at)
    FROM dbo.Message
    WHERE author_user_id = @UserID;

    RETURN @LastActivity;
END;
GO
