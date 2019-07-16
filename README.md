# Ruby Spending Tracker
A spending tracker web app using ruby, Sinatra and PSQL.

- Add Merchants and Tags 
- Create Transactions using those tags
- Filter transactions using multiple options concurrently
- Set a budget, and see how close you are to that budget for the last six months

## Setup

Navigate to the `spending_tracker` folder:


Set up tables:

`psql -d spending_tracker -f db/spending_tracker.sql`

## Run

`ruby app.rb`
