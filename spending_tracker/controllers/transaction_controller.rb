require('sinatra')
require('sinatra/contrib/all')
require('pry')
require('date')

require_relative('../models/transaction')
require_relative('../models/merchant')
require_relative('../models/tag')
require_relative('../models/budget')
also_reload( '../models/*' )

get '/transactions' do
  @transactions = Transaction.all
  @transaction_total = Transaction.total_transaction_amount
  @merchants = Merchant.all
  @tags = Tag.all
  erb(:'transactions/index')
end

get '/transactions/new' do
  @merchants = Merchant.all
  @tags = Tag.all
  date = Date.today
  #Should return todays date in YYYY-MM-DD Format
  @date_today = date.strftime('%F')
  @date_6_months_ago = date.prev_month(6).strftime('%F')
  erb(:'transactions/new')
end

post '/transactions' do
  transaction = Transaction.new(params)
  transaction.save
  redirect('/transactions')
end

post '/transactions/:id/delete' do
  transaction = Transaction.find(params['id'])
  transaction.delete
  redirect('/transactions')
end

get '/transactions/sort' do
  @transactions = Transaction.sort
  @transaction_total = Transaction.total_transaction_amount
  @merchants = Merchant.all
  @tags = Tag.all
  erb(:'transactions/index')
end

post '/transactions/filter_tag' do
  # @number = params['tag_id']
  if params['tag_id'].to_i > 0
    @transactions = Transaction.filter_tag(params['tag_id'])
  else
    @transactions = Transaction.all
  end
  @transaction_total = Transaction.total_transaction_amount
  @merchants = Merchant.all
  @tags = Tag.all
  erb(:'transactions/index')
end

post '/transactions/filter_merchant' do
  if params['merchant_id'].to_i > 0
    @transactions = Transaction.filter_merchant(params['merchant_id'])
  else
    @transactions = Transaction.all
  end
  @transaction_total = Transaction.total_transaction_amount
  @merchants = Merchant.all
  @tags = Tag.all
  erb(:'transactions/index')
end
