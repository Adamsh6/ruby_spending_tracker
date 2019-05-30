require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/transaction')
require_relative('../models/merchant')
require_relative('../models/tag')
require_relative('../models/budget')
also_reload( '../models/*' )

get '/transactions' do
  @transactions = Transaction.find_all
  erb(:'transactions/index')
end
