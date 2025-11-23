USE Discord;
GO

IF OBJECT_ID('dbo.ChannelStats', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChannelStats
    (
        channel_id    INT PRIMARY KEY,
        message_count INT NOT NULL DEFAULT (0),
        last_message_at DATETIME2 NULL,

        CONSTRAINT FK_ChannelStats_Channel
            FOREIGN KEY (channel_id)
            REFERENCES dbo.Channel(channel_id)
    );
END;
GO

IF OBJECT_ID('dbo.trg_Message_Insert_UpdateStats', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Message_Insert_UpdateStats;
GO

CREATE TRIGGER dbo.trg_Message_Insert_UpdateStats
ON dbo.Message
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE dbo.ChannelStats AS target
    USING
    (
        SELECT channel_id, MAX(sent_at) AS last_sent_at, COUNT(*) AS cnt
        FROM inserted
        GROUP BY channel_id
    ) AS src
    ON target.channel_id = src.channel_id
    WHEN MATCHED THEN
        UPDATE SET
            target.message_count   = target.message_count + src.cnt,
            target.last_message_at = src.last_sent_at
    WHEN NOT MATCHED THEN
        INSERT (channel_id, message_count, last_message_at)
        VALUES (src.channel_id, src.cnt, src.last_sent_at);
END;
GO
