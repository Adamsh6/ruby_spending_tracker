require('pg')
require("pry")
require_relative('../db/sql_runner')

class Budget

  attr_accessor :amount, :start_date
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'].to_f
@start_date = options['start_date']

  end

  def save
    sql = 'INSERT INTO budgets (amount, start_date) VALUES ($1, $2) RETURNING id'
    values = [@amount, @start_date]
    result = SqlRunner.run(sql, values)
    @id = result.first["id"].to_i
  end

  def update
    sql = 'UPDATE budgets SET (amount, start_date) = ($1, $2) WHERE id = $3'
    values = [@amount, @start_date, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM budgets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def transactions
    sql = "SELECT * FROM transactions WHERE budget_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{ |details| Transaction.new(details)}
  end

  def spent_this_month
    transactions_made = transactions
    total_spent = 0.0
    transactions_made.each{|transaction| total_spent += transaction.amount}
    return total_spent
  end

  def pretty_month
    date = @start_date
    current_month = "#{date.slice(5, 2)}/#{date.slice(0, 4)}"
    return current_month
  end

  def almost_over?
    total_spent = spent_this_month
    budget_left = @amount - total_spent
    limit = @amount * 0.9
    return true if (@amount - budget_left) > limit
    return false
  end

  def go_over?(amount)
    total_spent = spent_this_month
    return false if total_spent > @amount
    return true if (total_spent + amount) > @amount
    return false
  end

  def self.find(id)
    sql = 'SELECT * FROM budgets WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Budget.new(result[0])
  end

  def self.all
    sql = 'SELECT * FROM budgets'
    result = SqlRunner.run(sql)
    return self.map_items(result)
    # return result.map{ |item| Budget.new(item) }
  end

  def self.delete_all
    sql = "DELETE FROM budgets"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Budget.new( data ) }
    return result
  end

  def self.last_budget
    return self.all.last
  end


end
