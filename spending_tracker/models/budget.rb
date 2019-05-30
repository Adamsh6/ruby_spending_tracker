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

  def self.find(id)
    sql = 'SELECT * FROM budgets WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Budget.new(result[0])
  end

  def self.all
    sql = 'SELECT amount, start_date FROM budgets'
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


end
