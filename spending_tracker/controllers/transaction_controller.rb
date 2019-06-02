require('sinatra')
require('sinatra/contrib/all')
require('pry')
require('date')

require_relative('../models/transaction')
require_relative('../models/merchant')
require_relative('../models/tag')
require_relative('../models/budget')
require_relative('../models/date_handler')
also_reload( '../models/*' )

get '/transactions' do
  @transactions = Transaction.sort if @transactions == nil
  @transaction_total = Transaction.total_transaction_amount
  @merchants = Merchant.all
  @tags = Tag.all
  @months = DateHandler.last_six_months
  erb(:'transactions/index')
end

get '/transactions/new' do
  @merchants = Merchant.all
  @tags = Tag.all
  date = Date.today
  #Should return todays date in YYYY-MM-DD Format
  @date_today = date.strftime('%F')
  @date_6_months_ago = date.prev_month(6).strftime('%F')

  @date_today = DateHandler.date_today_long
  @date_6_months_ago = DateHandler.date_six_months_ago
  erb(:'transactions/new')
end

post '/transactions' do
  transaction = Transaction.new(params)
  transaction.save
  redirect('/transactions')
end

post '*/transactions/:id/delete' do
  transaction = Transaction.find(params['id'])
  transaction.delete
  redirect('/transactions')
end

get '/transactions/filter' do
  @transactions = Transaction.filter(params)
  @transaction_total = Transaction.total_transaction_amount(@transactions)
  @merchants = Merchant.all
  @tags = Tag.all
  @months = DateHandler.last_six_months
  erb(:'/transactions/index')
end

get '/transactions/filter_month' do
  @transactions = Transaction.filter_month(params['month'])
  @transaction_total = Transaction.total_transaction_amount(@transactions)
  @merchants = Merchant.all
  @tags = Tag.all
  @months = DateHandler.last_six_months
  erb(:'/transactions/index')
end
