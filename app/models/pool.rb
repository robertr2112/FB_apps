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

  has_many :users, :through => :pool_memberships
  has_many :pool_memberships

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
end
