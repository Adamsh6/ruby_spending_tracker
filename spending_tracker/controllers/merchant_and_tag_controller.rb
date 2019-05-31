require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/merchant')
require_relative('../models/tag')
also_reload( '../models/*' )

get '/merchants_and_tags' do
  @merchants = Merchant.all.reverse
  @tags = Tag.all.reverse
  erb(:"merchants_and_tags/index")
end

post '/merchants_and_tags/new_merchant' do
  merchant = Merchant.new(params)
  merchant.save
  redirect('merchants_and_tags')
end

post '/merchants_and_tags/new_tag' do
  tag = Tag.new(params)
  tag.save
  redirect('merchants_and_tags')
end

get '/merchants_and_tags/tag/:id' do

  erb(:'merchants_and_tags/tag')
end

get '/merchants_and_tags/merchant/:id' do

  erb(:'merchants_and_tags/merchant')
end
