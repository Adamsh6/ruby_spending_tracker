require('pg')
require("pry")
require_relative('date_handler')
require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :time_stamp, :merchant_id, :tag_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'].to_f
    @time_stamp = options['time_stamp']
    @merchant_id = options['merchant_id'].to_i
    @tag_id = options['tag_id'].to_i

  end

  def save
    sql = 'INSERT INTO transactions (amount, time_stamp, merchant_id, tag_id) VALUES ($1, $2, $3, $4) RETURNING id'
    values = [@amount, @time_stamp, @merchant_id, @tag_id]
    result = SqlRunner.run(sql, values)
    @id = result.first["id"].to_i
  end

  def update
    sql = 'UPDATE transactions SET (amount, time_stamp, merchant_id, tag_id) = ($1, $2, $3, $4) WHERE id = $5'
    values = [@amount, @time_stamp, @merchant_id, @tag_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM transactions WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def merchant
    sql = "SELECT * FROM merchants WHERE id = $1"
    values=[@merchant_id]
    result = SqlRunner.run(sql, values)
    return Merchant.new(result[0])
  end

  def tag
    sql = "SELECT * FROM tags WHERE id = $1"
    values=[@tag_id]
    result = SqlRunner.run(sql, values)
    return Tag.new(result[0])
  end

  def self.find(id)
    sql = 'SELECT * FROM transactions WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Transaction.new(result[0])
  end

  def self.all
    sql = 'SELECT * FROM transactions'
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM transactions"
    result = SqlRunner.run(sql)
  end
  #Takes in a transactions array, or defaults to all transactions if no argument
  def self.total_transaction_amount(transactions=self.all)
    total_spent = 0.0
    transactions.each{|transaction| total_spent += transaction.amount}
    return total_spent
  end

  def self.map_items(data)
    result = data.map { |data| Transaction.new( data ) }
    return result
  end

  def self.sort()
    sql = 'SELECT * FROM transactions ORDER BY time_stamp'
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  def self.filter_tag(tag_id)
    sql = 'SELECT * FROM transactions WHERE tag_id = $1'
    values = [tag_id]
    result = SqlRunner.run(sql, values)
    return self.map_items(result)
  end

  def self.filter_merchant(merchant_id)
    sql = 'SELECT * FROM transactions WHERE merchant_id = $1'
    values = [merchant_id]
    result = SqlRunner.run(sql, values)
    return self.map_items(result)
  end

  def self.filter_amount(lower_limit, upper_limit)
    sql = 'SELECT * FROM transactions WHERE amount BETWEEN SYMMETRIC $1 AND $2'
    values = [lower_limit.to_i, upper_limit.to_i]
    result = SqlRunner.run(sql, values)
    return self.map_items(result)
  end
  #Month given in YYYY-MM format
  def self.filter_month(date)
    sql = "SELECT * FROM transactions WHERE time_stamp BETWEEN SYMMETRIC $1 AND $2"
    date1 = date + '-01'
    date2 = DateHandler.add_last_day(date)
    values = [date1, date2]
    result = SqlRunner.run(sql, values)
    return self.map_items(result)
  end

  def self.filter(filter_options)
    sql = "SELECT * FROM transactions WHERE amount BETWEEN SYMMETRIC $1 AND $2"
      merchant_string = ' AND merchant_id = $3'
      tag_string = ' AND tag_id = '
    placeholder3 = "$3"
    placeholder4 = "$4"
    values = [filter_options['lower'], filter_options['upper']]
    if filter_options['merchant_id'].to_i > 0 && filter_options['tag_id'].to_i > 0
      sql += merchant_string + tag_string + placeholder4
      values << filter_options['merchant_id']
      values << filter_options['tag_id']
    elsif filter_options['merchant_id'].to_i > 0
      sql += merchant_string
      values << filter_options['merchant_id']
    elsif filter_options['tag_id'].to_i > 0
      sql += tag_string + placeholder3
      values << filter_options['tag_id']
    end

    result = SqlRunner.run(sql, values)
    return self.map_items(result)
  end







  def self.last_six_months_amounts
    months = DateHandler.last_six_months
    amount_array = []
    for month in months
      transactions = self.filter_month(month)
      amount_array << transactions.sum{|transaction| transaction.amount}
    end
    return amount_array
  end
end
