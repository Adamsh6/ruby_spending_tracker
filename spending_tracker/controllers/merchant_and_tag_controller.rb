require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/merchant')
require_relative('../models/tag')
also_reload( '../models/*' )

get '/merchants_and_tags' do
  erb(:"merchants_and_tags/index")
end
