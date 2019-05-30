require('pg')
require("pry")
require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :time_stamp, :merchant_id, :budgets_id, :tags_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'] 
@time_stamp = options['time_stamp'] 
@merchant_id = options['merchant_id'] 
@budgets_id = options['budgets_id'] 
@tags_id = options['tags_id'] 

  end

  def save
    sql = 'INSERT INTO transactions (amount, time_stamp, merchant_id, budgets_id, tags_id) VALUES ($1, $2, $3, $4, $5) RETURNING id'
    values = [@amount, @time_stamp, @merchant_id, @budgets_id, @tags_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id']
  end

  def update
    sql = 'UPDATE transactions SET (amount, time_stamp, merchant_id, budgets_id, tags_id) = ($1, $2, $3, $4, $5) WHERE id = $6'
    values = [@amount, @time_stamp, @merchant_id, @budgets_id, @tags_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM transactions WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = 'SELECT * FROM transactions WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Transaction.new(result[0])
  end

  def self.all
    sql = 'SELECT amount, time_stamp, merchant_id, budgets_id, tags_id FROM transactions'
    result = SqlRunner.run(sql)
    return self.map_items(result)
    # return result.map{ |item| Transaction.new(item) }
  end

  def self.delete_all
    sql = "DELETE FROM transactions"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Transaction.new( data ) }
    return result
  end


end
