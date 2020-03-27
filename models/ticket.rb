require_relative('../db/sql_runner')

class Ticket

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



end
