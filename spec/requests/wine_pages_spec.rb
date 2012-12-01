require 'spec_helper'

describe "Wine Pages" do

	subject { page }

	describe "index" do

		before { visit wines_path }

		it { should have_selector('title', 	text: 'All Wines') }
		it { should have_selector('h1', 	text: 'All Wines') }

		describe "wine pagination" do
			before(:all) 	{ 50.times { FactoryGirl.create(:wine) } }
			after(:all) 	{ Wine.delete_all}

			it { should have_selector('div.pagination') }

			it "should list each wine" do	
				Wine.all.each do |wine|
					page.should have_selector('a', text: wine.name)
				end
			end
		end
	end
	
end