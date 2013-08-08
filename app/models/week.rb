# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  state      :integer
#  pool_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Week < ActiveRecord::Base

  STATES = { Pend: 0, Open: 1, Closed: 2 }

  belongs_to :pool

  attr_accessible :state

  validates :state, :inclusion => { :in => 0..2 }

end
