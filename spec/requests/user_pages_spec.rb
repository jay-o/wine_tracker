 require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "index" do
		
		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_selector('title', text: 'All Users') }
		it { should have_selector('h1',    text: 'All Users') }


		describe "user pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all)  { User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.first_name)
				end
			end
		end


		describe "delete links" do
			it { should_not have_link('delete') }

			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end
	end

	describe "signup page" do
		before { visit signup_path }
	
		it { should have_selector('h1',    text: 'Sign up') }
		it { should have_selector('title', text: full_title('Sign up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('title', text: "#{user.first_name} #{user.last_name}'s Profile") }
		it { should have_selector('h1',    text: "#{user.first_name} #{user.last_name}") }
		it { should have_selector('h2',    text: "email: #{user.email}") }
	end

	describe "signup" do
		before { visit signup_path }
		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "First name",	with: "Example"
				fill_in "Last name",	with: "User"
				fill_in "Email",		with: "user@example.com"
				fill_in "Password",		with: "foobar"
				fill_in "Confirmation",	with: "foobar"
			end
			
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email('user@example.com') }

				it { should have_selector('title', text: user.first_name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
				it { should have_link('Sign out') }
				
				describe "followed by signout" do
					before { click_link "Sign out" }
					it { should have_link('Sign in') }
				end
			end
    	end
  	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_selector('h1',    text: "Update your profile") }
			it { should have_selector('title', text: "Edit user") }
		end

		describe "with invalid information" do
			before { click_button "Save changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_first)  { "New" }
			let(:new_last)  { "Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "First name",		with: new_first
				fill_in "Last name",		with: new_last
				fill_in "Email",			with: new_email
				fill_in "Password",			with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it { should have_selector('title', text: new_first) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { user.reload.first_name.should  == new_first }
			specify { user.reload.last_name.should  == new_last }
			specify { user.reload.email.should == new_email }
		end
  	end

  	describe "profile page"	do
  		let(:user) 	{ FactoryGirl.create(:user) }
  		let(:p1)	{ FactoryGirl.create(:post, user: user, content: "Foo") }
  		let(:p2)	{ FactoryGirl.create(:post, user: user, content: "Bar") }

  		before { visit user_path(user) }

  		it { should have_selector('title', 	text: user.first_name) }
  		it { should have_selector('h1', 	text: user.first_name) }
  		
  		describe "posts" do
  			xit { should have_content(p1.content) }
  			xit { should have_content(p2.content) }
  			xit { should have_content(user.posts.count) }
  		end
  	end
end