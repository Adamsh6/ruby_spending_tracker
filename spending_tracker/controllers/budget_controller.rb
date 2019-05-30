require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/budget')
also_reload( '../models/*' )
