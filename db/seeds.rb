require 'faker'

my_user = User.new({email: 'scottivincentj@gmail.com', password: 'password', password_confirmation: 'password', role: 1})
my_user.save
    
regular_user = User.new({email: 'regular@gmail.com', password: 'password', password_confirmation: 'password', role: 0})
regular_user.save

# Create Users
10.times do
User.create!(
        email:    Faker::Internet.email,
        password: Faker::Internet.password,
        role: 0
    )
end
10.times do
User.create!(
        email:    Faker::Internet.email,
        password: Faker::Internet.password,
        role: 1
    )
end
users = User.all


# Create  Wikis
50.times do
    Wiki.create!(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.sentences(5),
        private: Faker::Boolean.boolean(0.5),
        user: users.sample
    )
end
wikis = Wiki.all

premium_users = User.where(role: 1)
private_wikis = Wiki.where(private: true)

30.times do
    Collaborator.create!(
        user: premium_users.sample,
        wiki: private_wikis.sample
    )
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
puts "#{Collaborator.count} collaborators created"