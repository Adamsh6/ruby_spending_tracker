require("pry")
require_relative('../models/budget')
require_relative('../models/merchant')
require_relative('../models/tag')
require_relative('../models/transaction')

Budget.delete_all
Merchant.delete_all
Tag.delete_all
Transaction.delete_all

budget1 = Budget.new({'amount' => 1000.00, 'start_date' => '2019-05-01'});

merchant1 = Merchant.new({'name' => 'Amazon'})

tag1 = Tag.new({'name' => 'Groceries'})

transaction1 = Transaction.new({
  'amount' => 38.5,
  'budget_id' => 1,
  'tag_id' => 1,
  'merchant_id' => 1,
  'time_stamp' => '2019-05-01'
  })

budget1.save
merchant1.save
tag1.save


transaction1.save

binding.pry
nil
