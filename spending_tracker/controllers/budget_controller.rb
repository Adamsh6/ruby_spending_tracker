require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/budget')
also_reload( '../models/*' )

get '/budget' do
  @latest_budget = Budget.last_budget
  erb ( :"budgets/index" )
end
