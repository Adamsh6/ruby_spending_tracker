DROP TABLE tags;
DROP TABLE merchants;
DROP TABLE budgets;
DROP TABLE transactions;

CREATE TABLE budgets (
  id SERIAL4 PRIMARY KEY,
  amount DECIMAL(9, 2),
  start_date DATE
);

CREATE TABLE tags (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE merchants (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE transactions (
  id SERIAL4 PRIMARY KEY,
  amount DECIMAL(9, 2),
  time_stamp TIMESTAMP,
  merchant_id INT4 REFERENCES merchants(id),
  budgets_id INT4 REFERENCES budgets(id),
  tags_id INT4 REFERENCES tags(id)
)
