DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

 -- create users table
CREATE TABLE users (
  user_id     INTEGER PRIMARY KEY,
  full_name   TEXT NOT NULL,
  country     TEXT NOT NULL,
  created_at  TEXT NOT NULL -- ISO timestamp string for SQLite
);

-- create Subscriptions table (one user can have multiple periods over time)
CREATE TABLE subscriptions (
  subscription_id INTEGER PRIMARY KEY,
  user_id         INTEGER NOT NULL,
  plan            TEXT NOT NULL CHECK (plan IN ('free','basic','pro')),
  status          TEXT NOT NULL CHECK (status IN ('active','canceled','expired')),
  start_date      TEXT NOT NULL,
  end_date        TEXT,      -- nullable if active
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- create table Product events
CREATE TABLE events (
  event_id    INTEGER PRIMARY KEY,
  user_id     INTEGER NOT NULL,
  event_ts    TEXT NOT NULL,
  event_name  TEXT NOT NULL CHECK (event_name IN ('signup','login','trial_start','activate','feature_use','upgrade_click','purchase')),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- create table Payments
CREATE TABLE payments (
  payment_id  INTEGER PRIMARY KEY,
  user_id     INTEGER NOT NULL,
  paid_ts     TEXT NOT NULL,
  amount      REAL NOT NULL CHECK (amount >= 0),
  currency    TEXT NOT NULL DEFAULT 'USD',
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
