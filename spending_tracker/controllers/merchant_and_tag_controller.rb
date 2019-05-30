require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/merchant')
require_relative('../models/tag')
also_reload( '../models/*' )

get '/merchants_and_tags' do
  @merchants = Merchant.all
  @tags = Tag.all
  erb(:"merchants_and_tags/index")
end
