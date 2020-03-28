require_relative('../db/sql_runner')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save
    sql = "INSERT INTO films (title, price)
           VALUES ($1, $2)
           RETURNING *"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def customers
    sql = "SELECT customers.* FROM customers
           INNER JOIN tickets
           ON customers.id = tickets.customer_id
           WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return Customer.map_items(customers)
  end

  # checks the number of customers per film

  def number_of_customers
    return customers().size
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return Film.map_items(films)
  end

  def update
    sql = "UPDATE films
           SET (title, price) = ($1, $2)
           WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.map_items(film_data)
    result = film_data.map {|film| Film.new(film)}
    return result
  end

  # write a method that gives us all showings times per film

  def screenings
    sql = "SELECT * FROM screenings
           WHERE film_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return Screening.map_items(screenings)
  end

  def show_times
    screenings = screenings()
    return screenings.map {|screening| screening.showing_time}
  end

  def find_most_popular_screening
    screenings = screenings()
    result = screenings.max_by {|screening| screening.number_of_tickets}
  end

  # Write a method that finds out what is the most
  # popular time (most tickets sold) for a given film



end
