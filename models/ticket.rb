require_relative('../db/sql_runner')

class Ticket

  attr_accessor :customer_id, :film_id, :screening_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @screening_id = options['screening_id']
  end

  # CRUD methods

  # save method checks that the screening has capacity
  # and updates customer wallet at the end

  def save
    if screening_has_capacity?()
      sql = "INSERT INTO tickets (customer_id, film_id, screening_id)
           VALUES ($1, $2, $3)
           RETURNING *"
      values = [@customer_id, @film_id, @screening_id]
      @id = SqlRunner.run(sql, values)[0]['id'].to_i
      sell_ticket()
    else return "SOLD OUT"
    end
  end

  def self.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return Ticket.map_items(tickets)
  end

  def update
    sql = "UPDATE tickets
           SET (customer_id, film_id, screening_id) = $1, $2, $3
           WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM tickets
           WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def film
    sql = "SELECT * FROM films
           WHERE id = $1"
    values = [@film_id]
    result = SqlRunner.run(sql, values)[0]
    return Film.new(result)
  end

  def price
    result = film()
    return film.price.to_i
  end

  def sell_ticket
    customer = customer()
    price = price()
    customer.funds = customer.funds.to_i - price
    customer.update
  end

  def screening
    sql = "SELECT * FROM screenings
           WHERE id = $1"
    values = [@screening_id]
    screening = SqlRunner.run(sql, values)[0]
    return Screening.new(screening)
  end

  def customer
    sql = "SELECT * FROM customers
           WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer)
  end

  def screening_has_capacity?
    screening = screening()
    tickets = screening.number_of_tickets
    return true if screening.capacity.to_i > tickets
  end

  def self.map_items(ticket_data)
    result = ticket_data.map {|ticket| Ticket.new(ticket)}
    return result
  end

end
