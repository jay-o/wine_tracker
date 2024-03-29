# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

require 'spec_helper'

describe User do

	before do
		@user = User.new(	first_name: "Example", 
							last_name: "User", 
							email: "user@example.com", 
							password: "foobar", 
							password_confirmation: "foobar"
							)
	end

	subject { @user }

	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
  	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) } 
	it { should respond_to(:admin) }
	it { should respond_to(:authenticate) }
  	it { should respond_to(:posts) }
	
	it { should be_valid }
	it { should_not be_admin }

	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end
	
	# tests presence of
	describe "when first_name is not present" do
		before { @user.first_name = " " }
		it { should_not be_valid }
	end

	describe "when last_name is not present" do
		before { @user.last_name = " " }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	
	# tests lengths
	describe "when first_name is too long" do
		before { @user.first_name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when last_name is too long" do
		before { @user.last_name = "a" * 51 }
		it { should_not be_valid }
	end

	# Test Email Formats
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[	user@foo,com 
							user_at_foo.org 
							example.user@foo. 
							foo@bar_baz.com 
							foo@bar+baz.com
							]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end      
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[	user@foo.COM 
							A_US-ER@f.b.org 
							frst.lst@foo.jp 
							a+b@baz.cn
							]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end      
		end

		
	end	

	# Verifies email is saved into db downcased
	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
		it "should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
		end
	end

	# Tests Email Uniqueness
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it { should_not be_valid }
	end	

	# Passwords and Password Confirmation
	# Tests Password is not blank
	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	# Test for catching Password Mismatch
	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	# Test for catching Password = nil (would only be possible through the console)
	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end	


	# A test for a valid (nonblank) remember token. 
	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	# Posts Tests
	describe "post associations" do
		before { @user.save }
		let!(:older_post) do
			FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_post) do
			FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right posts in the right order" do
			@user.posts.should == [newer_post, older_post]
		end

		it "should destroy associated posts when user deleted" do
			posts = @user.posts.dup
			@user.destroy
			posts.should_not be_empty
			posts.each do |p|
				Post.find_by_id(p.id).should be_nil
			end
		end

		describe "status" do
			let(:unfollowed_post) do
				FactoryGirl.create(:post, user: FactoryGirl.create(:user))
			end

			its(:feed) { should include(newer_post) }
			its(:feed) { should include(older_post) }
			its(:feed) { should_not include(unfollowed_post) }
		end
	end
end
