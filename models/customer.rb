require_relative('../db/sql_runner.rb')
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

  # MOVIE OBJECT SELECTING ALL STARS FROM SELF MOVIE
  # "SELECT stars.* FROM stars INNER JOIN castings ON stars.id = castings.star_id WHERE castings.movie_id = $1"

end
