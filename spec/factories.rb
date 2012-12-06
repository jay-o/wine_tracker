FactoryGirl.define do
	factory :user do
		sequence(:first_name)  	{ |n| "First" }
		sequence(:last_name)  	{ |n| "Last #{n}" }
  		sequence(:email) 		{ |n| "person_#{n}@example.com"}  
		password 				"foobar"
		password_confirmation 	"foobar"

		factory :admin do
			admin true
		end
	end

	factory :wine do
		name 			"Wine" 
		year 			"2000"
	end

	factory :post do
		content "Lorem ipsum"
		user
	end
end