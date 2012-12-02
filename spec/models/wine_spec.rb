# == Schema Information
#
# Table name: wines
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Wine do

	before do
		@wine = Wine.new(	name: "2008 Pinot Noir Reserve",
							description: "The best Pinot in Napa",
							year:        "2001"
							)
	end

	subject { @wine }

	it { should respond_to(:name) }
	it { should respond_to(:description) }
	it { should respond_to(:year) }

	it { should be_valid }

	describe "when wine name is not present" do
		before { @wine.name = " " }
		it { should_not be_valid }
	end

	describe "when wine year is not present" do
		before { @wine.year= " " }
		it { should_not be_valid }
	end

	# Length Validations
	describe "when name is too long" do
		before { @wine.name = "a" * 101 }
		it { should_not be_valid }
	end

	describe "when year is too short" do
		before { @wine.year = 123 }
		it { should_not be_valid }
	end

	describe "when year is too long" do
		before { @wine.year = 12345 }
		it { should_not be_valid }
	end

end
