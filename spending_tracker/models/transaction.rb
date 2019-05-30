require('pg')
require("pry")
require_relative('../db/sql_runner')

class Transaction

  attr_accessor :amount, :time_stamp, :merchant_id, :budget_id, :tag_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'].to_f
@time_stamp = options['time_stamp']
@merchant_id = options['merchant_id'].to_i
@budget_id = options['budget_id'].to_i
@tag_id = options['tag_id'].to_i

  end

  def save
    sql = 'INSERT INTO transactions (amount, time_stamp, merchant_id, budget_id, tag_id) VALUES ($1, $2, $3, $4, $5) RETURNING id'
    values = [@amount, @time_stamp, @merchant_id, @budget_id, @tag_id]
    result = SqlRunner.run(sql, values)
    @id = result.first["id"].to_i
  end

  def update
    sql = 'UPDATE transactions SET (amount, time_stamp, merchant_id, budget_id, tag_id) = ($1, $2, $3, $4, $5) WHERE id = $6'
    values = [@amount, @time_stamp, @merchant_id, @budget_id, @tag_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM transactions WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def budget
    sql = "SELECT * FROM budgets WHERE id = $1"
    values=[@budget_id]
    result = SqlRunner.run(sql, values)
    return Budget.new(result[0])
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
    sql = 'SELECT amount, time_stamp, merchant_id, budget_id, tag_id FROM transactions'
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
