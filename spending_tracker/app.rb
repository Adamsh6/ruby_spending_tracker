require('sinatra')
require('sinatra/contrib/all')

require_relative('controllers/budget_controller')
require_relative('controllers/transaction_controller')
require_relative('controllers/merchant_and_tag_controller')

get '/' do
  erb( :index )
end
