INSERT INTO users (user_id, full_name, country, created_at) VALUES
(1,'Richie Patel','USA','2025-10-02 09:10:00'),
(2,'Rakshit Patel','USA','2025-10-10 10:20:00'),
(3,'Mia Singh','Canada','2025-10-12 12:00:00'),
(4,'Liam Garcia','UK','2025-10-20 08:30:00'),
(5,'Sophia Kim','USA','2025-11-01 14:15:00'),
(6,'Ethan Brown','Germany','2025-11-03 16:45:00'),
(7,'Isabella Martinez','India','2025-11-05 11:05:00'),
(8,'Oliver Wilson','USA','2025-11-10 09:55:00');

INSERT INTO subscriptions (subscription_id, user_id, plan, status, start_date, end_date) VALUES
(101,1,'pro','active','2025-11-01',NULL),
(102,2,'basic','active','2025-11-15',NULL),
(103,3,'free','active','2025-10-12',NULL),
(104,4,'basic','canceled','2025-10-25','2025-11-20'),
(105,5,'pro','active','2025-12-01',NULL),
(106,6,'basic','expired','2025-11-01','2025-11-30'),
(107,7,'free','active','2025-11-05',NULL),
(108,8,'basic','active','2025-12-03',NULL);

INSERT INTO events (event_id, user_id, event_ts, event_name) VALUES
(1,1,'2025-10-02 09:10:00','signup'),
(2,1,'2025-10-02 09:12:00','trial_start'),
(3,1,'2025-11-01 10:00:00','purchase'),
(4,1,'2025-11-05 12:00:00','feature_use'),

(5,2,'2025-10-10 10:20:00','signup'),
(6,2,'2025-11-14 17:10:00','upgrade_click'),
(7,2,'2025-11-15 09:00:00','purchase'),
(8,2,'2025-11-16 09:30:00','feature_use'),

(9,3,'2025-10-12 12:00:00','signup'),
(10,3,'2025-10-13 08:00:00','login'),
(11,3,'2025-10-20 18:00:00','feature_use'),

(12,4,'2025-10-20 08:30:00','signup'),
(13,4,'2025-10-25 10:00:00','purchase'),
(14,4,'2025-11-20 09:00:00','login'),

(15,5,'2025-11-01 14:15:00','signup'),
(16,5,'2025-12-01 10:00:00','purchase'),
(17,5,'2025-12-05 09:10:00','feature_use'),

(18,6,'2025-11-03 16:45:00','signup'),
(19,6,'2025-11-10 12:00:00','purchase'),

(20,7,'2025-11-05 11:05:00','signup'),
(21,7,'2025-11-07 09:00:00','trial_start'),
(22,7,'2025-11-08 10:00:00','feature_use'),

(23,8,'2025-11-10 09:55:00','signup'),
(24,8,'2025-12-03 08:30:00','purchase'),
(25,8,'2025-12-04 09:15:00','feature_use');

INSERT INTO payments (payment_id, user_id, paid_ts, amount, currency) VALUES
(1,1,'2025-11-01 10:00:00',29.00,'USD'),
(2,2,'2025-11-15 09:00:00',12.00,'USD'),
(3,4,'2025-10-25 10:00:00',12.00,'USD'),
(4,5,'2025-12-01 10:00:00',29.00,'USD'),
(5,6,'2025-11-10 12:00:00',12.00,'USD'),
(6,8,'2025-12-03 08:30:00',12.00,'USD');
