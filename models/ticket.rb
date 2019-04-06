require_relative('../db/sql_runner.rb')

class Ticket

  attr_reader :id, :customer_id, :film_id



  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def save
    sql = "INSERT INTO tickets
    (
      customer_id,
      film_id
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id
    "
    values = [@customer_id, @film_id]
    result_hash_array = SqlRunner.run(sql, values)
    @id = result_hash_array.first['id']
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

end
