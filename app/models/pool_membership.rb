# == Schema Information
#
# Table name: pool_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  pool_id    :integer
#  owner      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PoolMembership < ActiveRecord::Base

  belongs_to :user
  belongs_to :pool

end
