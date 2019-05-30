require('sinatra')
require('sinatra/contrib/all')
require('controllers/budget_controller')
require('controllers/transaction_controller')
require('controllers/merchant_and_tag_controller')

get '/' do
  erb( :index )
end
