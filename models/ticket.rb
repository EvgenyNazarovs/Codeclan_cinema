require_relative('../db/sql_runner')

class Ticket

  attr_accessor :customer_id, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']
  end

  def save
    sql = "INSERT INTO tickets (customer_id, film_id)
           VALUES ($1, $2)
           RETURNING *"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
    buy_ticket()
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
    return film.price
  end

  def customer_funds
    result = customer()
    return customer.funds
  end

  def buy_ticket
    customer = customer()
    price = price().to_i
    customer.funds = customer.funds.to_i - price
    customer.update
  end

  def customer
    sql = "SELECT * FROM customers
           WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return Ticket.map_items(tickets)
  end

  def self.map_items(ticket_data)
    result = ticket_data.map {|ticket| Ticket.new(ticket)}
    return result
  end

  # class v



end
