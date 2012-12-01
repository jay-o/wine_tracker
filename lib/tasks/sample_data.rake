namespace :db do
	desc "Fill database with sample data"
		task populate: :environment do
			admin = User.create!(	first_name: 	"Jay",
									last_name: 		"Otto",
									email: 			"jay@test.com",
									password: 		"foobar",
									password_confirmation: "foobar")
			admin.toggle!(:admin)
			
		99.times do |n|
			first_name  = Faker::Name.first_name
			last_name  	= Faker::Name.last_name
			email 		= "example-#{n+1}@test.com"
			password  	= "password"
			User.create!(	first_name: first_name,
							last_name: 	last_name,
							email: 		email,
							password: 	password,
							password_confirmation: password)
		end
	end
end