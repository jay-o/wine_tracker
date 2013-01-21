# == Schema Information
#
# Table name: user_wines
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  wine_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserWine < ActiveRecord::Base
  attr_accessible :user_id, :wine_id

  belongs_to :user
  belongs_to :wine
end
