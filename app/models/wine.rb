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

class Wine < ActiveRecord::Base
  attr_accessible :name, :description, :year

  has_many :user_wines
  has_many :users, through: :user_wines

  validates :name, presence: true, length: { maximum: 100 }
  validates :year, presence: true, length: { is: 4 }
end
