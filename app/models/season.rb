# == Schema Information
#
# Table name: seasons
#
#  id              :integer          not null, primary key
#  year            :string(255)
#  state           :integer
#  nfl_league      :boolean
#  number_of_weeks :integer
#  current_week    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Season < ActiveRecord::Base
  
  before_create do
    self.year = Time.now.strftime("%Y")
    self.current_week = 1
    self.state = Season::STATES[:Pend]
  end
  
  STATES = { Pend: 0, Open: 1, Closed: 2 }
  
  has_many :pools
  has_many :weeks
  
  def setState(new_state)
    self.update_attribute(:state, new_state)
  end

  def checkStatePend
    self.state == Season::STATES[:Pend]
  end

  def checkStateOpen
    self.state == Season::STATES[:Open]
  end

  def checkStateClosed
    self.state == Season::STATES[:Closed]
  end
  
  def canBeClosed?
    if self.weeks.empty?
      return false
    end
    if self.weeks.count != self.number_of_weeks
      return false
    end
    self.weeks.order(:week_number).each do
      if !week.checkStateFinal
	return false
      end
    end
    return true
  end
  
  def open?
    checkStateOpen
  end

  def closed?
    checkStateClosed
  end
  
  def getCurrentWeek
    current_week = self.weeks.where(week_number: self.current_week)
  end

end
