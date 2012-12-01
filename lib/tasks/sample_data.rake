namespace :db do
	desc "Fill database with sample data"
		task populate: :environment do
			make_users
			make_wines
#			make_user_wine_relationship
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
	
	50.times do |n|
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
	10.times do |n|
		name 		= Faker::Company.name
		description = Faker::Company.catch_phrase
		maker_id 	= (1..30).to_a.shuffle.first
		region_id 	= (1..30).to_a.shuffle.first
		varietal_id = (1..30).to_a.shuffle.first
		year	 	= (1950..2012).to_a.shuffle.first
		Wine.create!(	name: 			name,
						description: 	description, 		
						maker_id: 		maker_id,
						region_id: 		region_id,
						varietal_id: 	varietal_id,
						year: 			year
						)
	end
end
