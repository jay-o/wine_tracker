require 'spec_helper'

describe "Post Pages" do
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "post creation" do
		before { visit root_path }

		describe "with invalid information" do
			it "should not create post"	do
				expect { click_button "Post" }.not_to change(Post, :count)	
			end

			describe "should have error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before { fill_in 'post_content', with: 'Lorem ipsum' }

			it "should create post" do
				expect { click_button 'Post' }.to change(Post, :count).by(1)
			end
		end
	end

	describe "post destruction"	do
		before { FactoryGirl.create(:post, user: user) }

		describe "as correct user" do
			before { visit root_path }

			it "should delete a post" do
				expect { click_link "delete"}.to change(Post, :count).by(-1)
			end
		end
	end
end
