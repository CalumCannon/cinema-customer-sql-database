require_relative('../db/sql_runner.rb')

class Ticket

  attr_reader :id, :customer_id, :film_id, :showing_time



  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @showing_time = options['showing_time']
  end

  def save
    sql = "INSERT INTO tickets
    (
      customer_id,
      film_id,
      showing_time
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id
    "
    values = [@customer_id, @film_id, @showing_time]
    result_hash_array = SqlRunner.run(sql, values)
    @id = result_hash_array.first['id']
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def self.all
   sql = "SELECT * FROM tickets"
   result = SqlRunner.run(sql)
   return result.map { |ticket| Ticket.new(ticket)}
  end

  def self.most_popular_film
    # go through data work out what film_id shows up the most

  end

end
