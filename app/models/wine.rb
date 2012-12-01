# == Schema Information
#
# Table name: wines
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  maker_id    :integer
#  region_id   :integer
#  varietal_id :integer
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Wine < ActiveRecord::Base
  attr_accessible :name, :description, :maker_id, :region_id, :varietal_id, :year

  validates :name, presence: true, length: { maximum: 100 }
  validates :maker_id, presence: true
  validates :region_id, presence: true
  validates :varietal_id, presence: true
  validates :year, presence: true, length: { is: 4 }
end
