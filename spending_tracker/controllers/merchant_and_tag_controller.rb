require('sinatra')
require('sinatra/contrib/all')
require('pry')

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
  params['color'] = '#999'
  tag = Tag.new(params)
  # binding.pry
  tag.save
  redirect('merchants_and_tags')
end

get '/merchants_and_tags/tag/:id' do
  @tag = Tag.find(params['id'])
  erb(:'merchants_and_tags/tag')
end

get '/merchants_and_tags/merchant/:id' do
  @merchant = Merchant.find(params['id'])
  erb(:'merchants_and_tags/merchant')
end

post '/merchants_and_tags/tag/:id' do
  params['color'] = '#411'
  tag = Tag.new(params)
  tag.update
  redirect('/merchants_and_tags')
end

post '/merchants_and_tags/merchant/:id' do
  merchant = Merchant.new(params)
  merchant.update
  redirect('/merchants_and_tags')
end

post '/merchants_and_tags/merchant/:id/delete' do
  merchant = Merchant.find(params['id'])
  merchant.delete
  redirect('/merchants_and_tags')
end

post '/merchants_and_tags/tag/:id/delete' do
  tag = Tag.find(params['id'])
  tag.delete
  redirect('/merchants_and_tags')
end
