require_relative('../db/sql_runner')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
    @cinecard = options['cinecard']
  end

  # CRUD methods

  def save
    sql = "INSERT INTO customers (name, funds)
           VALUES ($1, $2)
           RETURNING *"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return Customer.map_items(customers)
  end

  def update
    sql = "UPDATE customers
           SET (name, funds) = ($1, $2)
           WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM customers
           WHERE id = $1"
    values =[@id]
    SqlRunner.run(sql, values)
  end

  # shows which films a customer booked to see

  def films
    sql = "SELECT films.* FROM films
           INNER JOIN tickets
           ON films.id = tickets.film_id
           WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return Film.map_items(films)
  end

  def tickets
    sql = "SELECT * FROM tickets
           WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return nil if results.first == nil
    return Ticket.map_items(results)
  end

  # checks how many tickets were bought by a customer

  def number_of_tickets
    result = tickets()
    return result.size
  end

  def self.map_items(customer_data)
    result = customer_data.map {|customer| Customer.new(customer)}
    return result
  end

end
