DROP TABLE transactions;
DROP TABLE tags;
DROP TABLE merchants;
DROP TABLE budgets;


CREATE TABLE budgets (
  id SERIAL8 PRIMARY KEY,
  amount DECIMAL(9, 2),
  start_date DATE
);

CREATE TABLE tags (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE merchants (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE transactions (
  id SERIAL4 PRIMARY KEY,
  amount DECIMAL(9, 2),
  time_stamp TIMESTAMP,
  merchant_id INT8 REFERENCES merchants(id),
  budget_id INT8 REFERENCES budgets(id),
  tag_id INT8 REFERENCES tags(id)
);
