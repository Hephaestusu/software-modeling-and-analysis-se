USE Discord;  
GO


/* =========================================================
   1. All messages with server name and channel name
   ========================================================= */
SELECT 
    m.message_id,
    s.name    AS server_name,
    c.name    AS channel_name,
    u.username,
    m.content,
    m.sent_at
FROM Message   AS m
JOIN Channel   AS c ON m.channel_id = c.channel_id
JOIN [Server]  AS s ON c.server_id  = s.server_id
JOIN [User]    AS u ON m.author_user_id = u.user_id
ORDER BY m.sent_at DESC;
GO


/* =========================================================
   2. Message count per server (general activity statistics)
   ========================================================= */
SELECT 
    s.server_id,
    s.name AS server_name,
    COUNT(m.message_id) AS message_count
FROM [Server] AS s
LEFT JOIN Channel AS c ON c.server_id = s.server_id
LEFT JOIN Message AS m ON m.channel_id = c.channel_id
GROUP BY s.server_id, s.name
ORDER BY message_count DESC, server_name;
GO


/* =========================================================
   3. Top active users (ranked by messages sent)
   ========================================================= */
SELECT TOP 10
    u.user_id,
    u.username,
    COUNT(m.message_id) AS messages_sent
FROM [User] AS u
LEFT JOIN Message AS m ON m.author_user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY messages_sent DESC, u.username;
GO


/* =========================================================
   4. Using the function fn_UserLastActivity
      (shows last activity timestamp for each user)
   ========================================================= */
SELECT 
    u.user_id,
    u.username,
    dbo.fn_UserLastActivity(u.user_id) AS last_activity
FROM [User] AS u
ORDER BY last_activity DESC;
GO


/* =========================================================
   5. Checking the trigger-generated ChannelStats table
      (messages count and last message time per channel)
   ========================================================= */
SELECT 
    c.channel_id,
    s.name AS server_name,
    c.name AS channel_name,
    ISNULL(cs.message_count, 0)  AS message_count,
    cs.last_message_at
FROM Channel        AS c
JOIN [Server]       AS s  ON c.server_id = s.server_id
LEFT JOIN ChannelStats AS cs ON cs.channel_id = c.channel_id
ORDER BY s.name, c.name;
GO


/* =========================================================
   6. Number of members per server
   ========================================================= */
SELECT 
    s.server_id,
    s.name      AS server_name,
    COUNT(mb.user_id) AS members_count
FROM [Server] AS s
LEFT JOIN Membership AS mb ON mb.server_id = s.server_id
GROUP BY s.server_id, s.name
ORDER BY members_count DESC, server_name;
GO


/* =========================================================
   7. Users who participate in more than one server
   ========================================================= */
SELECT 
    u.user_id,
    u.username,
    COUNT(mb.server_id) AS servers_count
FROM [User] AS u
JOIN Membership AS mb ON mb.user_id = u.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(mb.server_id) > 1
ORDER BY servers_count DESC, username;
GO


/* =========================================================
   8. Channels with total attachments (files/images)
   ========================================================= */
SELECT
    c.channel_id,
    s.name AS server_name,
    c.name AS channel_name,
    COUNT(a.attachment_id) AS attachments_count
FROM Channel   AS c
JOIN [Server]  AS s ON c.server_id = s.server_id
LEFT JOIN Message    AS m ON m.channel_id = c.channel_id
LEFT JOIN Attachment AS a ON a.message_id = m.message_id
GROUP BY c.channel_id, s.name, c.name
ORDER BY attachments_count DESC, server_name, channel_name;
GO


/* =========================================================
   9. Last message in every channel (using subquery)
   ========================================================= */
SELECT
    c.channel_id,
    s.name AS server_name,
    c.name AS channel_name,
    m.message_id,
    u.username AS author,
    m.content,
    m.sent_at
FROM Channel AS c
JOIN [Server] AS s ON c.server_id = s.server_id
LEFT JOIN Message AS m 
       ON m.channel_id = c.channel_id
      AND m.sent_at =
          (
              SELECT MAX(m2.sent_at)
              FROM Message AS m2
              WHERE m2.channel_id = c.channel_id
          )
LEFT JOIN [User] AS u ON u.user_id = m.author_user_id
ORDER BY s.name, c.name;
GO


/* =========================================================
   10. Activity per server in the last 7 days
       (messages written within the latest week)
   ========================================================= */
SELECT
    s.server_id,
    s.name AS server_name,
    COUNT(m.message_id) AS messages_last_7_days
FROM [Server] AS s
LEFT JOIN Channel AS c ON c.server_id = s.server_id
LEFT JOIN Message AS m 
       ON m.channel_id = c.channel_id
      AND m.sent_at >= DATEADD(DAY, -7, SYSUTCDATETIME())
GROUP BY s.server_id, s.name
ORDER BY messages_last_7_days DESC, server_name;
GO
