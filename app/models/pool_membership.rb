# == Schema Information
#
# Table name: pool_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  pool_id    :integer
#  owner      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PoolMembership < ActiveRecord::Base

  belongs_to :user
  belongs_to :pool, :dependent => :destroy

  attr_accessible :pool_id, :owner

end
