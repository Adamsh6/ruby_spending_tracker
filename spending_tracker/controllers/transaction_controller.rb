require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/transaction')
require_relative('../models/merchant')
require_relative('../models/tag')
require_relative('../models/budget')
also_reload( '../models/*' )

get '/transactions' do
  @transactions = Transaction.all
  @transaction_total = Transaction.total_transaction_amount
  erb(:'transactions/index')
end

get '/transactions/new' do
  @merchants = Merchant.all
  @tags = Tag.all
  erb(:'transactions/new')
end

post '/transactions' do
  params['budget_id'] = Budget.last_budget.id
  transaction = Transaction.new(params)
  transaction.save
  redirect('/transactions')
end
