require 'random_data'

# Create Users
5.times do
User.create!(
        email:    RandomData.random_email,
        password: RandomData.random_sentence
    )
end
users = User.all

# Create Topics
15.times do
    Wiki.create!(
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph
    )
end
wikis = Wiki.all

puts "Seed finished"
puts "#{Wiki.count} wikis created"