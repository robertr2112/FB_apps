# == Schema Information
#
# Table name: pools
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  season_id       :integer
#  poolType        :integer
#  allowMulti      :boolean          default(FALSE)
#  isPublic        :boolean          default(TRUE)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Pool < ActiveRecord::Base

  POOL_TYPES = { PickEm: 0, PickEmSpread: 1, Survivor: 2, SUP: 3 }

  has_many   :users, through: :pool_memberships, dependent: :destroy
  has_many   :pool_memberships, dependent: :destroy
  has_many   :entries, dependent: :destroy
  belongs_to :season

  # Make sure protected fields aren't updated after a week has been created on the pool
  validate :checkUpdateFields, on: :update

  attr_accessor :password

  validates :name,     presence:   true,
                       length:      { :maximum => 30 },
                       uniqueness:  { :case_sensitive => false }
  validates :poolType, inclusion:   { in: 0..3 }
  validates :allowMulti, inclusion: { in: [true, false] }
  validates :isPublic, inclusion:   { in: [true, false] }

  def self.typeSUP?(type)
    if type == POOL_TYPES[:SUP]
      return true
    end
    return false
  end
  
  def self.typePickEm?(type)
    if type == POOL_TYPES[:PickEm]
      return true
    end
    return false
  end
  
  def self.typePickEmSpread?(type)
    if type == POOL_TYPES[:PickEmSpread]
      return true
    end
    return false
  end
  
  def self.typeSurvivor?(type)
    if type == POOL_TYPES[:Survivor]
      return true
    end
    return false
  end
  
  def typeSUP?
    if self.type == POOL_TYPES[:SUP]
      return true
    end
    return false
  end
  
  def typePickEm?
    if self.type == POOL_TYPES[:PickEm]
      return true
    end
    return false
  end
  
  def typePickEmSpread?
    if self.type == POOL_TYPES[:PickEmSpread]
      return true
    end
    return false
  end
  
  def typeSurvivor?
    if self.type == POOL_TYPES[:Survivor]
      return true
    end
    return false
  end
  
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

  # !!!! Need to modify this routine to work and update all calls to it
  def updateEntries
    winning_teams = self.getWinningTeams
    picks = self.picks
    picks.each do |pick|
      pick.game_picks.each do |game_pick|
        found_team = false
        winning_teams.each do |team|
          if game_pick.chosenTeamIndex == team 
            found_team = true
          end
        end
        if !found_team 
          entry = Entry.find(pick.entry_id)
          entry.update_attribute(:survivorStatusIn, false)
          entry.save
        end
      end
    end
    return true
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
    season = Season.find(self.season_id)
    season.getCurrentWeek
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
