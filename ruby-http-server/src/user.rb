require 'securerandom'

class User
  @@users = {
    "matt" => { "pass" => "&234", "visits" => 0, "session" => SecureRandom.hex },
    "andy" => { "pass" => "test", "visits" => 0, "session" => SecureRandom.hex }
  }

  def initialize(username, password)
    @@users[username] = { "pass" => password, "visits" => 0 }
  end

  def self.all
    @@users
  end
end
