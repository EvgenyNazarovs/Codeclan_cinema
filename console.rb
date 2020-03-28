require('pry-byebug')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/customer')
require_relative('models/screening')

Ticket.delete_all
Film.delete_all
Customer.delete_all
Screening.delete_all

film1 = Film.new({'title' => 'Blue Velvet', 'price' => 10})
film2 = Film.new({'title' => 'The League of Gentlement Marathon', 'price' => 20})
film3 = Film.new({'title' => 'Inception', 'price' => 10})
film4 = Film.new({'title' => 'Solaris', 'price' => 12})

film1.save
film2.save
film3.save
film4.save

customer1 = Customer.new({'name' => 'Neil', 'funds' => 50})
customer2 = Customer.new({'name' => 'Ivan', 'funds' => 70})
customer3 = Customer.new({'name' => 'Rob', 'funds' => 60})

customer1.save
customer2.save
customer2.name = 'Chris'
customer2.update
customer3.save

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id})
ticket3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film3.id})
ticket4 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film4.id})
ticket5 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film2.id})
ticket6 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})

ticket1.save
ticket2.save
ticket3.save
ticket4.save
ticket5.save
ticket6.save

screening1 = Screening.new({'film_id' => film1.id, 'showing_time' => '15:00', 'capacity' => 50})
screening2 = Screening.new({'film_id' => film1.id, 'showing_time' => '18:00', 'capacity' => 50})
screening3 = Screening.new({'film_id' => film1.id, 'showing_time' => '21:00', 'capacity' => 25})

screening1.save
screening2.save
screening3.save

binding.pry
nil
