require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/budget')
require_relative('../models/transaction')
require_relative('../models/date_handler')
also_reload( '../models/*' )

get '/budget' do
  @latest_budget = Budget.last_budget
  @total_spent = Transaction.total_transaction_amount

  @budgets = Budget.last_six_months
  @total_transactions = Transaction.last_six_months_amounts
  @months = DateHandler.last_six_months
  erb ( :"budgets/index" )
end

post '/budget' do
  @latest_budget = Budget.last_budget
  @latest_budget.amount = params['amount']
  @latest_budget.update
  redirect('/budget')
end
