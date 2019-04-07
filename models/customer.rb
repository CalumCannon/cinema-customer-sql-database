require_relative('../db/sql_runner.rb')


class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options["id"].to_i if options['id']
    @name = options["name"]
    @funds = options['funds'].to_i
  end

  def save
    sql = 'INSERT INTO customers
    (
      name,
      funds
    ) VALUES
    (
      $1, $2
    ) RETURNING id'
    values = [@name, @funds]
    result_hash_array = SqlRunner.run(sql, values)
    @id = result_hash_array.first['id']
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def update
    sql = "UPDATE customers SET (name, funds) = ($1,$2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql,values)
  end

  def films
    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE tickets.customer_id = $1"
    values = [@id]
    films_hash_array = SqlRunner.run(sql,values)
    return films_hash_array.map{|film| Film.new(film)}
  end

  def buy_ticket(film)

    if(@funds - film.price < 0)
      p "No more money!"
      return
    end

    if(film.tickets_left <= 0)
      p "No more tickets!"
      return
    end

    film.remove_ticket

    @funds -= film.price
    update()

  end

  def tickets_purchased
    return films.count
  end

  def self.all
   sql = "SELECT * FROM customers"
   result = SqlRunner.run(sql)
   return result.map { |customer| Customer.new(customer)}
  end

end
