require 'faker'
require 'marky_markov'
require_relative '../app/models/label'
require_relative '../app/models/email'

class Seeder
  USERS = ["matt.baker@example.com", "burt.malkiel@example.com"]
  EMAIL_ADDRESSES = 15.times.map {Faker::Internet.email}

  def initialize
    puts "loading dictionary.."
    @dict = MarkyMarkov::Dictionary.new("moby_dicktionary")
    puts "finished loading"

    @labels = [
      Label.find_or_create_by!(name:'DBC', color:'0c0'),
      Label.find_or_create_by!(name:'To-Do', color:'00c'),
      Label.find_or_create_by!(name:'Urgent', color:'c00'),
    ]
  end

  def create_random_email
    create_email(USERS.sample)
  end

  def create_email(to)
    Email.create!(
      to: to,
      from: EMAIL_ADDRESSES.sample,
      subject: @dict.generate_3_words,
      body: @dict.generate_5_sentences,
      labels: @labels.sample(rand(3)),
      read: rand(5) == 0
    )
  end
end
