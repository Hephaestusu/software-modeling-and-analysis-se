    CREATE DATABASE Discord;
GO

USE Discord;
GO

IF OBJECT_ID('dbo.Attachment', 'U') IS NOT NULL DROP TABLE dbo.Attachment;
IF OBJECT_ID('dbo.Message', 'U')    IS NOT NULL DROP TABLE dbo.Message;
IF OBJECT_ID('dbo.Emoji', 'U')      IS NOT NULL DROP TABLE dbo.Emoji;
IF OBJECT_ID('dbo.Membership', 'U') IS NOT NULL DROP TABLE dbo.Membership;
IF OBJECT_ID('dbo.Role', 'U')       IS NOT NULL DROP TABLE dbo.Role;
IF OBJECT_ID('dbo.Channel', 'U')    IS NOT NULL DROP TABLE dbo.Channel;
IF OBJECT_ID('dbo.[Server]', 'U')   IS NOT NULL DROP TABLE dbo.[Server];
IF OBJECT_ID('dbo.[User]', 'U')     IS NOT NULL DROP TABLE dbo.[User];
GO

CREATE TABLE dbo.[User]
(
    user_id        INT IDENTITY(1,1) PRIMARY KEY,
    username       NVARCHAR(32)  NOT NULL,
    discriminator  CHAR(4)       NOT NULL,
    email          NVARCHAR(255) NOT NULL UNIQUE,
    [status]       NVARCHAR(32)  NULL,
    created_at     DATETIME2     NOT NULL
        CONSTRAINT DF_User_CreatedAt DEFAULT SYSUTCDATETIME()
);
GO


CREATE TABLE dbo.[Server]
(
    server_id      INT IDENTITY(1,1) PRIMARY KEY,
    name           NVARCHAR(100) NOT NULL,
    region         NVARCHAR(50)  NULL,
    is_public      BIT           NOT NULL
        CONSTRAINT DF_Server_IsPublic DEFAULT (0),
    [description]  NVARCHAR(500) NULL,
    created_at     DATETIME2     NOT NULL
        CONSTRAINT DF_Server_CreatedAt DEFAULT SYSUTCDATETIME(),
    owner_user_id  INT NULL
        CONSTRAINT FK_Server_OwnerUser
            REFERENCES dbo.[User](user_id)
);
GO


CREATE TABLE dbo.Channel
(
    channel_id  INT IDENTITY(1,1) PRIMARY KEY,
    server_id   INT           NOT NULL,
    name        NVARCHAR(100) NOT NULL,
    [type]      NVARCHAR(20)  NOT NULL,
    topic       NVARCHAR(250) NULL,
    created_at  DATETIME2     NOT NULL
        CONSTRAINT DF_Channel_CreatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Channel_Server
        FOREIGN KEY (server_id)
        REFERENCES dbo.[Server](server_id)
);
GO


CREATE TABLE dbo.Role
(
    role_id      INT IDENTITY(1,1) PRIMARY KEY,
    server_id    INT          NOT NULL,
    name         NVARCHAR(64) NOT NULL,
    color        NVARCHAR(7)  NULL,
    position     INT          NOT NULL
        CONSTRAINT DF_Role_Position DEFAULT (0),
    mentionable  BIT          NOT NULL
        CONSTRAINT DF_Role_Mentionable DEFAULT (0),

    CONSTRAINT FK_Role_Server
        FOREIGN KEY (server_id)
        REFERENCES dbo.[Server](server_id),

    CONSTRAINT UQ_Role_Server_Name
        UNIQUE (server_id, name)
);
GO


CREATE TABLE dbo.Membership
(
    server_id   INT NOT NULL,
    user_id     INT NOT NULL,
    join_date   DATETIME2     NOT NULL
        CONSTRAINT DF_Membership_JoinDate DEFAULT SYSUTCDATETIME(),
    nickname    NVARCHAR(100) NULL,
    is_muted    BIT           NOT NULL
        CONSTRAINT DF_Membership_IsMuted DEFAULT (0),
    is_deafened BIT           NOT NULL
        CONSTRAINT DF_Membership_IsDeafened DEFAULT (0),

    CONSTRAINT PK_Membership
        PRIMARY KEY (server_id, user_id),

    CONSTRAINT FK_Membership_Server
        FOREIGN KEY (server_id)
        REFERENCES dbo.[Server](server_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_Membership_User
        FOREIGN KEY (user_id)
        REFERENCES dbo.[User](user_id)
        ON DELETE CASCADE
);
GO


CREATE TABLE dbo.Emoji
(
    emoji_id    INT IDENTITY(1,1) PRIMARY KEY,
    server_id   INT          NOT NULL,
    name        NVARCHAR(64) NOT NULL,
    emoji_type  NVARCHAR(20) NOT NULL,
    created_at  DATETIME2    NOT NULL
        CONSTRAINT DF_Emoji_CreatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Emoji_Server
        FOREIGN KEY (server_id)
        REFERENCES dbo.[Server](server_id)
);
GO


CREATE TABLE dbo.Message
(
    message_id     BIGINT IDENTITY(1,1) PRIMARY KEY,
    channel_id     INT      NOT NULL,
    author_user_id INT      NOT NULL,
    content        NVARCHAR(MAX) NULL,
    sent_at        DATETIME2 NOT NULL
        CONSTRAINT DF_Message_SentAt DEFAULT SYSUTCDATETIME(),
    is_pinned      BIT      NOT NULL
        CONSTRAINT DF_Message_IsPinned DEFAULT (0),

    CONSTRAINT FK_Message_Channel
        FOREIGN KEY (channel_id)
        REFERENCES dbo.Channel(channel_id),

    CONSTRAINT FK_Message_User
        FOREIGN KEY (author_user_id)
        REFERENCES dbo.[User](user_id)
);
GO

CREATE INDEX IX_Message_Channel_SentAt
    ON dbo.Message(channel_id, sent_at);
GO

CREATE TABLE dbo.Attachment
(
    attachment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    message_id    BIGINT        NOT NULL,
    filename      NVARCHAR(260) NOT NULL,
    url           NVARCHAR(500) NOT NULL,

    CONSTRAINT FK_Attachment_Message
        FOREIGN KEY (message_id)
        REFERENCES dbo.Message(message_id)
        ON DELETE CASCADE
);
GO
