# == Schema Information
#
# Table name: pools
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  poolType           :integer
#  isPublic           :boolean
#  encrypted_password :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Pool < ActiveRecord::Base

  has_many :users, :through => :pool_memberships, :dependent => :destroy
  has_many :pool_memberships, :dependent => :destroy

  attr_accessor :password
  attr_accessible  :name, :poolType, :isPublic, :password

  validates :name,     :presence     => true,
                       :length       => { :maximum => 30 },
                       :uniqueness    => { :case_sensitive => false }
  validates :poolType, :inclusion => { :in => 0..3 }
  validates :isPublic, :inclusion => {:in => [true, false]}

  # Need to look at copying the password mgmt from User class.  Also, need to look
  # at how to include the function definitions in both without having a copy in both
  #before_save :encrypt_password

  def isMember?(user)
    self.pool_memberships.find_by_user_id(user.id)
  end

  def isOwner?(user)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    if pool_membership
      pool_membership.owner
    end
  end

  def setOwner(user, flag)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    if pool_membership
      pool_membership.owner = flag
      pool_membership.save
    end
  end

  def addUser(user)
    user.pools << self
    self.setOwner(user, false)
    user.save
  end

  def removeUser(user)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    pool_membership.destroy
  end

end
