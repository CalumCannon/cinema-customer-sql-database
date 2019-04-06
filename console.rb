require_relative('models/film')
require_relative('models/ticket')
require_relative('models/customer')
require('pry-byebug')

film1 = Film.new({
  'title' => 'blade Runner',
  'price' => 15
  })
film1.save()

film2 = Film.new({
  'title' => 'Children of Men',
  'price' => 13
  })
film2.save()

customer1 = Customer.new({
  'name' => 'deckard',
  'funds' => 80
  })
customer1.save()

customer2 = Customer.new({
  'name' => 'Rachael',
  'funds' => 100
  })
customer2.save()

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film2.id
  })
ticket2.save()

ticket3 = Ticket.new({
  'customer_id' => customer2.id,
  'film_id' => film1.id
  })
ticket3.save()


film1.title = 'Blade Runner'
film1.update()

customer1.name = 'Rick Deckard'
customer1.update()

# film1.delete
# customer1.delete
# ticket1.delete

 binding.pry

nil
