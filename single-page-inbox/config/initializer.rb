def seed_loop
  s = Seeder.new
  Thread.new do
    while true
      sleep(5)
      5.times { s.create_random_email }
    end
  end
end

seed_loop
