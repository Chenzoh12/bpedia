require 'faker'

# Create Users
5.times do
User.create!(
        email:    Faker::Internet.email,
        password: Faker::Internet.password
    )
end
users = User.all


# Create Wikis
15.times do
    Wiki.create!(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.sentences(5),
        private: Faker::Boolean.boolean(0.5),
        user: users.sample
    )
end
wikis = Wiki.all

# Create collaborators:
30.times do
    Collaborator.create!(
        user: users.sample,
        wiki: wikis.sample
    )
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
puts "#{Collaborator.count} collaborators created"