# == Schema Information
#
# Table name: pools
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  poolType        :integer
#  isPublic        :boolean          default(TRUE)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Pool < ActiveRecord::Base

  POOL_TYPES = { PickEm: 0, PickEmSpread: 1, Survivor: 2, SUP: 3 }

  has_many :users, through: :pool_memberships, dependent: :destroy
  has_many :pool_memberships, dependent: :destroy
  has_many :weeks, dependent: :destroy
  has_many :entries, dependent: :destroy

  # Make sure protected fields aren't updated after a week has been created on the pool
  validate :checkUpdateFields, on: :update

  attr_accessor :password

  validates :name,     presence:   true,
                       length:      { :maximum => 30 },
                       uniqueness:  { :case_sensitive => false }
  validates :poolType, inclusion:   { in: 0..3 }
  validates :allowMulti, inclusion: { in: [true, false] }
  validates :isPublic, inclusion:   { in: [true, false] }

  def isMember?(user)
    self.pool_memberships.find_by_user_id(user.id)
  end

  def isOwner?(user)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    if pool_membership
      pool_membership.owner
    end
  end

  def isOpen?
    if self.weeks.empty?
      return true
    else
      weeks = self.weeks.order(:week_number)
      if weeks.first.checkStateClosed || weeks.first.checkStateFinal
        return false
      else
        return true
      end
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
    # Add user to the pool and save 
    user.pools << self
    self.setOwner(user, false)
    user.save
    # Create an entry in the pool for this user
    entry_name = self.getEntryName(user)
    new_entry_params = { name: entry_name }
    self.entries.create(new_entry_params.merge(user_id: user.id))
  end

  def removeUser(user)
    self.removeEntries(user)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    pool_membership.destroy
  end

  def getEntryName(user)
    entries = self.entries.where(user_id: user.id)
    if user.name.split(" ").count > 1
      user_nickname = user.name.split(" ")[0] + user.name.split(" ")[1][0]
    else
      user_nickname = user.name
    end
    if entries && entries.count > 0
        user_nickname = user_nickname + "_#{entries.count}"
    end
    return user_nickname
  end


  def removeEntries(user)
    entries = Entry.where({ pool_id: self.id, user_id: user.id })
    entries.each do |entry|
      picks = Pick.where(entry_id: entry.id)
      picks.each do |pick|
        pick.destroy
      end
      entry.destroy
    end
  end

  def getCurrentWeek
    #
    # Search through the weeks to find the current week.  Loop through all weeks
    # until you find a week that isn't marked final.  The first week not marked
    # as final is the current week. If there are no weeks then return nil. If it
    # goes through the whole list without finding a non-final week than the last
    # week in the Pool is still the current week.
    #
    weeks = self.weeks.order(:week_number)
    weeks.empty? { return nil }
    weeks.each do |week|
      if !week.checkStateFinal
        return week
      end
    end
    return self.weeks.last
  end


  private

    def pool_valid?
      if self.poolType != Pool::POOL_TYPES[:Survivor]
        if self.poolType == Pool::POOL_TYPES[:PickEm]
          type = "PickEm"
        elsif self.poolType == Pool::POOL_TYPES[:PickEmSpread]
          type = "PickEmSpread"
        else
          type = "SUP"
        end
        return true
      end
      return false
    end

    def checkUpdateFields
      if !self.weeks.empty?
        if (self.changed & ["poolType", "allowMulti"]).any?
          self.errors[:poolType] << "You can only change the Pool Name once a week has been created!"
        end
      end
    end
end
