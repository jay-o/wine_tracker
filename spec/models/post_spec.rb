# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Post do
	let(:user) { FactoryGirl.create(:user) }
	before 	{ @post = user.posts.build(content: 'Lorem') }

	subject { @post }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to the user_id" do
			expect do
				Post.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user is not present" do
		before { @post.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { @post.content = " " }
		it { should_not be_valid }
	end
end
