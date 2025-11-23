USE Discord;
GO

IF OBJECT_ID('dbo.CreateMessage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CreateMessage;
GO

CREATE PROCEDURE dbo.CreateMessage
    @ChannelID     INT,
    @AuthorUserID  INT,
    @Content       NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Channel WHERE channel_id = @ChannelID)
    BEGIN
        RAISERROR('Channel does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.[User] WHERE user_id = @AuthorUserID)
    BEGIN
        RAISERROR('User does not exist.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.Message (channel_id, author_user_id, content)
    VALUES (@ChannelID, @AuthorUserID, @Content);
END;
GO
