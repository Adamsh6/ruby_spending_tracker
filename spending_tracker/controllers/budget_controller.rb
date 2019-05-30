require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/budget')
also_reload( '../models/*' )

get '/budget' do
  @latest_budget = Budget.all.last
  erb ( :"budgets/index" )
end
