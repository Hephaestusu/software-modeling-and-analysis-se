USE Discord;
GO


INSERT INTO [User] (username, discriminator, email, [status])
VALUES 
('Alice',     '0001', 'alice@example.com',      'online'),
('Bob',       '0002', 'bob@example.com',        'idle'),
('Charlie',   '0003', 'charlie@example.com',    'offline'),
('Diana',     '0004', 'diana@example.com',      'online'),
('Eugene',    '0005', 'eugene@example.com',     'dnd'),
('Fiona',     '0006', 'fiona@example.com',      'online'),
('George',    '0007', 'george@example.com',     'idle'),
('Hannah',    '0008', 'hannah@example.com',     'online'),
('Ivan',      '0009', 'ivan@example.com',       'offline'),
('Julia',     '0010', 'julia@example.com',      'online');
GO


INSERT INTO [Server] (name, region, is_public, [description], owner_user_id)
VALUES
( N'Gamers Hub',     'eu-central', 1, N'Gaming community',                     1),
( N'Study Server',   'eu-west',    0, N'University study group',               2), 
( N'Music Lounge',   'eu-west',    1, N'Music sharing and listening party',    4), 
( N'Dev Community',  'us-east',    1, N'Developers discussing code & projects',5); 
GO

INSERT INTO Channel (server_id, name, [type], topic)
VALUES
(1, 'general',      'text',  N'General gaming chat'),
(1, 'lfg',          'text',  N'Looking for group'),
(1, 'voice-main',   'voice', N'Main voice channel'),

(2, 'announcements','text',  N'Important announcements'),
(2, 'homework',     'text',  N'Homework questions and help'),
(2, 'exams',        'text',  N'Exam preparation'),
(2, 'voice-study',  'voice', N'Quiet study room'),

(3, 'now-playing',  'text',  N'What are you listening to?'),
(3, 'requests',     'text',  N'Song requests'),
(3, 'voice-music',  'voice', N'Music listening'),

(4, 'general-dev',  'text',  N'General development chat'), 
(4, 'help',         'text',  N'Ask for coding help'),      
(4, 'showcase',     'text',  N'Share your projects'),      
(4, 'jobs',         'text',  N'Job postings and internships'); 
GO

INSERT INTO Role (server_id, name, color, position, mentionable)
VALUES
(1, 'Admin',      '#ff0000', 1, 1),
(1, 'Mod',        '#ff8800', 2, 1),
(1, 'Member',     '#00ff00', 3, 1),

(2, 'Teacher',    '#0000ff', 1, 1),
(2, 'Student',    '#ffff00', 2, 1),

(3, 'DJ',         '#ff00ff', 1, 1),
(3, 'Listener',   '#00ffff', 2, 1),

(4, 'Owner',      '#ffffff', 1, 1),
(4, 'Contributor','#00ffcc', 2, 1),
(4, 'Newbie',     '#888888', 3, 1);
GO

INSERT INTO Membership (server_id, user_id, nickname, is_muted, is_deafened)
VALUES
(1, 1, 'Alice',    0, 0),
(1, 2, 'Bob',      0, 0),
(1, 3, 'Charlie',  1, 0),
(1, 4, 'Diana',    0, 0),
(1, 5, 'Eugene',   0, 0),

(2, 2, 'Bob',      0, 0),
(2, 3, 'Charlie',  0, 0),
(2, 6, 'Fiona',    0, 0),
(2, 7, 'George',   0, 0),
(2, 8, 'Hannah',   0, 0),

(3, 1, 'Alice',    0, 0),
(3, 4, 'Diana',    0, 0),
(3, 6, 'Fiona',    0, 0),
(3, 9, 'Ivan',     0, 0),
(3,10, 'Julia',    0, 0),

(4, 5, 'Eugene',   0, 0),
(4, 7, 'George',   0, 0),
(4, 8, 'Hannah',   0, 0),
(4, 9, 'Ivan',     0, 0),
(4,10, 'Julia',    0, 0);
GO


INSERT INTO Emoji (server_id, name, emoji_type)
VALUES
(1, 'pog',          'custom'),
(1, 'pepeLaugh',    'custom'),
(1, 'GG',           'custom'),
(2, 'check',        'unicode'),
(2, 'warning',      'unicode'),
(3, 'music_note',   'unicode'),
(3, 'bassdrop',     'custom'),
(4, 'bug',          'unicode'),
(4, 'ship_it',      'custom');
GO

DECLARE @now DATETIME2 = SYSUTCDATETIME();

INSERT INTO Message (channel_id, author_user_id, content, sent_at, is_pinned)
VALUES
(1, 1, N'Welcome to Gamers Hub! Read the rules and have fun.', DATEADD(DAY, -3, @now), 1),
(1, 2, N'Hi everyone, what games are you playing today?',       DATEADD(DAY, -3, DATEADD(HOUR, 2, @now)), 0),
(1, 3, N'Anyone up for some Valorant later?',                   DATEADD(DAY, -2, @now), 0),
(1, 4, N'I''m down for League of Legends tonight.',             DATEADD(DAY, -2, DATEADD(HOUR, 3, @now)), 0),

(2, 2, N'Looking for 2 people for Apex ranked.',                DATEADD(DAY, -1, DATEADD(HOUR, -5, @now)), 0),
(2, 5, N'Need a healer for Overwatch quick play.',              DATEADD(DAY, -1, DATEADD(HOUR, -2, @now)), 0),
(2, 1, N'Creating a Minecraft survival world, join me!',        DATEADD(DAY, -1, @now), 0),

(4, 2, N'Exam date moved to next Friday. Check the syllabus.',  DATEADD(DAY, -5, @now), 1),
(4, 6, N'I uploaded lecture notes in the shared drive.',        DATEADD(DAY, -4, DATEADD(HOUR, 1, @now)), 0),

(5, 3, N'Has anyone solved problem 3 from the DB homework?',    DATEADD(DAY, -3, DATEADD(HOUR, -4, @now)), 0),
(5, 6, N'Yes, I can explain the ER diagram part.',              DATEADD(DAY, -3, DATEADD(HOUR, -2, @now)), 0),
(5, 7, N'I''m still stuck on normalization, help pls.',         DATEADD(DAY, -3, @now), 0),

(6, 8, N'Let''s create a shared set of flashcards.',            DATEADD(DAY, -2, DATEADD(HOUR, -1, @now)), 0),

(8, 4, N'Now playing: Lo-fi beats to relax/study to.',          DATEADD(DAY, -2, DATEADD(HOUR, 5, @now)), 0),
(8, 6, N'Listening to some synthwave, any recommendations?',    DATEADD(DAY, -1, DATEADD(HOUR, -6, @now)), 0),
(8, 9, N'New album from my favorite band just dropped!',        DATEADD(DAY, -1, DATEADD(HOUR, -3, @now)), 0),

(9,10, N'Can someone queue some jazz next?',                    DATEADD(DAY, -1, DATEADD(MINUTE, -30, @now)), 0),

(11,5, N'Welcome to Dev Community! Share what you are working on.', DATEADD(HOUR, -6, @now), 1),
(11,7, N'I''m building a Discord bot in C#.',                   DATEADD(HOUR, -5, @now), 0),
(11,8, N'Trying to understand Entity Framework migrations.',    DATEADD(HOUR, -4, @now), 0),

(12,9, N'Why is my query so slow? Any indexing tips?',          DATEADD(HOUR, -3, @now), 0),
(12,5, N'Post the execution plan, we can take a look.',         DATEADD(HOUR, -2, @now), 0),

(13,10,N'I made a small game in Unity, feedback appreciated!',  DATEADD(HOUR, -1, @now), 0),
(13,5, N'Nice work! The lighting looks great.',                 DATEADD(MINUTE, -40, @now), 0),

(14,7, N'Junior backend position open at our company, DM me.',  DATEADD(MINUTE, -20, @now), 0),
(14,8, N'Looking for internship opportunities in summer.',      DATEADD(MINUTE, -10, @now), 0);
GO


INSERT INTO Attachment (message_id, filename, url)
VALUES
(9,  N'db_lecture_notes.pdf',   N'https://example.com/db_lecture_notes.pdf'),
(10, N'homework3_solution.png', N'https://example.com/homework3_solution.png'),
(15, N'lofi_playlist.txt',      N'https://example.com/lofi_playlist'),
(22, N'unity_game_build.zip',   N'https://example.com/unity_game_build.zip');
GO
