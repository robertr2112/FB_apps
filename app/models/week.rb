# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  state      :integer
#  pool_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Week < ActiveRecord::Base

  STATES = { Pend: 0, Open: 1, Closed: 2 }

  belongs_to :pool
  has_many   :games, :dependent => :destroy

  #validates :state, :inclusion => { :in => 0..2 }

  accepts_nested_attributes_for :games

  def setState(state)
    self.state = state
    self.save
  end

end
