require_relative('../db/sql_runner')

class Screening

  attr_accessor :showing_time, :film_id, :capacity
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @showing_time = options['showing_time']
    @capacity = options['capacity']
  end

  def save
    sql = "INSERT INTO screenings (film_id, showing_time, capacity)
           VALUES ($1, $2, $3)
           RETURNING *"
    values = [@film_id, @showing_time, @capacity]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.map_items(screening_data)
    result = screening_data.map {|screening| Screening.new(screening)}
    return result
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
