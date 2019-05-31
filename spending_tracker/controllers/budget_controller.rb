require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/budget')
require_relative('../models/transaction')
also_reload( '../models/*' )

get '/budget' do
  @latest_budget = Budget.last_budget
  # @total_spent = Transaction.total_transaction_amount
  erb ( :"budgets/index" )
end
