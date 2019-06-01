require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/budget')
require_relative('../models/transaction')
require_relative('../models/date_handler')
also_reload( '../models/*' )

get '/budget' do
  @latest_budget = Budget.last_budget
  @total_spent = Transaction.total_transaction_amount
  @date_today_compact = Date.today.strftime('%Y-%m')

  @budgets = Budget.last_six_months
  @total_transactions = Transaction.last_six_months_amounts
  @months = DateHandler.last_six_months
  erb ( :"budgets/index" )
end

post '/budget' do
  @latest_budget = Budget.last_budget
  date_today = Date.today.strftime('%F')
  date_today_compact = Date.today.strftime('%Y-%m')
  if DateHandler.compare_month(date_today_compact, @latest_budget.start_date) == 1
    params['start_date'] = date_today
    @latest_budget = Budget.new(params)
    @latest_budget.save
  else
    @latest_budget.amount = params['amount']
    @latest_budget.update
  end
  redirect('/budget')
end
