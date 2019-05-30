require('pg')
require("pry")
require_relative('../db/sql_runner')

class Tag

  attr_accessor :name
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']

  end

  def save
    sql = 'INSERT INTO tags (name) VALUES ($1) RETURNING id'
    values = [@name]
    result = SqlRunner.run(sql, values)
    @id = result.first["id"].to_i
  end

  def update
    sql = 'UPDATE tags SET name = $1 WHERE id = $2'
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tags WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def transactions
    sql = "SELECT * FROM transactions WHERE tag_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map{ |details| Transaction.new(details)}
  end

  def self.find(id)
    sql = 'SELECT * FROM tags WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values)
    return Tag.new(result[0])
  end

  def self.all
    sql = 'SELECT name FROM tags'
    result = SqlRunner.run(sql)
    return self.map_items(result)
    # return result.map{ |item| Tag.new(item) }
  end

  def self.delete_all
    sql = "DELETE FROM tags"
    result = SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map { |data| Tag.new( data ) }
    return result
  end


end
