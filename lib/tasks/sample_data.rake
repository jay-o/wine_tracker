namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_wines
		make_user_posts
		make_user_wine_relationship
	end
end


# Add fake users
def make_users
	admin = User.create!(	first_name: 	"Jay",
							last_name: 		"Otto",
							email: 			"jay@test.com",
							password: 		"foobar",
							password_confirmation: "foobar")
	admin.toggle!(:admin)
	
	25.times do |n|
		first_name  = Faker::Name.first_name
		last_name  	= Faker::Name.last_name
		email 		= "example-#{n+1}@test.com"
		password  	= "password"
		User.create!(	first_name: first_name,
						last_name: 	last_name,
						email: 		email,
						password: 	password,
						password_confirmation: password
						)
	end
end


# Add fake wines
def make_wines
	50.times do |n|
		name 		= Faker::Company.name
		description = Faker::Company.catch_phrase
		year	 	= (1950..2012).to_a.shuffle.first
		Wine.create!(	name: 			name,
						description: 	description, 		
						year: 			year
						)
	end
end

# Add fake user posts
def make_user_posts
	users = User.all(limit: 10)
	15.times do |n|
		content = Faker::Lorem.sentence(5)
		users.each { |u| u.posts.create!(content: content) }
	end
end


# Add fake make_user_wine_relationship
def make_user_wine_relationship
	user = User.all
	user.each do |u|
		x = (1..10).to_a.shuffle.first
		w = (1..10).to_a.shuffle
		n = 0
		x.times do
			n += 1
			u.user_wines.create!( wine_id: w[n] )
		end
	end

end