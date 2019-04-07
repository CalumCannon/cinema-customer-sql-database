require_relative('../db/sql_runner.rb')
require('pry-byebug')

class Film

  attr_reader :id, :tickets_left
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
    @tickets_left = 5
  end

  def save
    sql = 'INSERT INTO films
    (
      title,
      price,
      tickets_left
    ) VALUES
    (
      $1, $2, $3
    ) RETURNING id'
    values = [@title, @price, @tickets_left]
    result_hash_array = SqlRunner.run(sql, values)
    @id = result_hash_array.first['id']
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def update
    sql = "UPDATE films SET (title, price, tickets_left) = ($1,$2, $3) WHERE id = $4"
    values = [@title, @price,@tickets_left, @id]
    SqlRunner.run(sql,values)
  end

  def customers
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE tickets.film_id = $1"
    values = [@id]
    customers_hash_array = SqlRunner.run(sql,values)
    return customers_hash_array.map{|film| Customer.new(film)}
  end

  def customer_count
    return customers.count
  end

  def remove_ticket
    @tickets_left -= 1
    update
  end

  def self.all
   sql = "SELECT * FROM films"
   result = SqlRunner.run(sql)
   return result.map { |film| Customer.new(film)}
  end

  def attendees_count
    sql = "SELECT COUNT(film_id) FROM tickets WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql,values)[0]
    return result
  end

  def self.most_popular_film
    sql = "SELECT film_id, COUNT(*) FROM tickets GROUP BY film_id ORDER BY count DESC LIMIT 1;"
    result = SqlRunner.run(sql)[0]

    sql2 = "SELECT * FROM films WHERE id = $1"
    values = [result["film_id"]]
    result2 = SqlRunner.run(sql2, values).first
    # binding.pry
    return Film.new(result2)
  end

end
