-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

WITH daily_counts AS (
    SELECT
        sender_id,
        DATE(sent_at) AS day,
        COUNT(message_id) AS number_msg
    FROM npn_messages
    GROUP BY sender_id, DATE(sent_at)
),
ranked_users AS (
    SELECT
        sender_id,
        day,
        number_msg,
        DENSE_RANK() OVER (
            PARTITION BY day
            ORDER BY number_msg DESC
        ) AS rn
    FROM daily_counts
)
SELECT
    r.day,
    u.user_id,
    u.user_name,
    r.number_msg
FROM ranked_users r
JOIN npn_users u
    ON r.sender_id = u.user_id
WHERE r.rn = 1
ORDER BY r.day;
