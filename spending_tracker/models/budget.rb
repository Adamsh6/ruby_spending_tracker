require('pg')
require("pry")
require_relative('../db/sql_runner')
require_relative('date_handler')

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

  def spent_this_month
    transactions_made = Transaction.filter_month(@start_date.slice(0,7))
    total_spent = 0.0
    transactions_made.each{|transaction| total_spent += transaction.amount}
    return total_spent
  end

  def pretty_month
    date = @start_date
    current_month = "#{date.slice(5, 2)}/#{date.slice(0, 4)}"
    return current_month
  end

  def over?
    total_spent = spent_this_month
    return true if total_spent >= @amount
    return false
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
    return true if (total_spent + amount) > @amount && total_spent < @amount
    return false
  end

  def self.last_six_months
    months_array = DateHandler.last_six_months
    # Array of budget objects, starting from the latest
    budgets = self.all.reverse
    iterator = 0
    budget_array = []
    for month in months_array
              # binding.pry
      comparitor = DateHandler.compare_month(month, budgets[iterator].start_date)
      case comparitor
      when 1
        budget_array << budgets[iterator]

      when 0
        budget_array << budgets[iterator]
        iterator += 1
      else
        raise "Month parsing error"
      end
    end
    return budget_array
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
