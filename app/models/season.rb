# == Schema Information
#
# Table name: seasons
#
#  id              :integer          not null, primary key
#  year            :string(255)
#  nfl_league      :boolean
#  number_of_weeks :integer
#  current_week    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Season < ActiveRecord::Base
  
  before_save(on: :create) do
    self.year = Time.now.strftime("%Y")
    self.current_week = 1
  end
  
  has_many :pools
  has_many :weeks
end
