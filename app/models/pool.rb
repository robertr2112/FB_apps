# == Schema Information
#
# Table name: pools
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  season_id       :integer
#  poolType        :integer
#  starting_week   :integer          default(1)
#  allowMulti      :boolean          default(FALSE)
#  isPublic        :boolean          default(TRUE)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Pool < ActiveRecord::Base

  POOL_TYPES = { PickEm: 0, PickEmSpread: 1, Survivor: 2, SUP: 3 }

  has_many   :users, through: :pool_memberships
  has_many   :pool_memberships
  has_many   :entries, dependent: :delete_all
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

  #
  # The following routines check the poolType. There is both a Class and
  # an Instance version of each routine.
  #
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
    if self.poolType == POOL_TYPES[:SUP]
      return true
    end
    return false
  end
  
  def typePickEm?
    if self.poolType == POOL_TYPES[:PickEm]
      return true
    end
    return false
  end
  
  def typePickEmSpread?
    if self.poolType == POOL_TYPES[:PickEmSpread]
      return true
    end
    return false
  end
  
  def typeSurvivor?
    if self.poolType == POOL_TYPES[:Survivor]
      return true
    end
    return false
  end

  #
  # Used to determine if the listed user is a member in the pool
  #
  def isMember?(user)
    self.pool_memberships.find_by_user_id(user.id)
  end

  #
  # Used to determine if the listed user is the owner of the pool.
  #
  def isOwner?(user)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    if pool_membership
      pool_membership.owner
    end
  end

  #
  # This is used to determine if users can join/leave the pool.  Once the pool is no longer open then
  # users cannot join or leave the pool.
  #
  def isOpen?
    season = Season.find(self.season_id)
    first_week = season.weeks.find_by_week_number(1)
    if self.typeSurvivor?
      if first_week.checkStateClosed || first_week.checkStateFinal
        return false
      else
        return true
      end
    else
      return true
    end
  end

  #
  # Used to set/remove ownership of the pool from the listed user
  #
  def setOwner(user, flag)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    if pool_membership
      pool_membership.owner = flag
      pool_membership.save
    end
  end

  #
  #  Adds the listed user to the pool
  #
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

  #
  # Removes the listed user from the pool
  #
  def removeUser(user)
    self.removeEntries(user)
    pool_membership = self.pool_memberships.find_by_user_id(user.id)
    pool_membership.destroy
  end

  #
  # Removes all memberships from the pool
  #
  def remove_memberships
    users = self.users.each do |user|
      pool_membership = self.pool_memberships.find_by_user_id(user.id)
      pool_membership.destroy
    end
  end

  #
  # Used to get a default entry name for a user.  The default is <first name><Last name first Initial>
  # for the first entry and then adds _<entry number>
  #
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

  #
  # This routine is used to update the survivor status and SUP total points for those pools
  # for each entry.  It is called after a week is marked final.
  def updateEntries(current_week)
    if self.typeSurvivor?
      updateSurvivor(current_week)
    elsif self.typeSUP?
      updateSUP(current_week)
    elsif self.typePickEm?
      updatePickEm(current_week)
    elsif self.typePickEmSpread?
      updatePickEmSpread(current_week)
    end
  end

  #
  # Used to remove all entries for a user from the pool.  It is called when a user leaves
  # the pool
  def removeEntries(user)
    puts "pool.id: #{self.id},user.id: #{user.id}"
    entries = Entry.where({ pool_id: self.id, user_id: user.id })
    entries.each do |entry|
      puts "entry.id: #{entry.id}"
      entry.recurse_delete
    end
  end

  #
  # Used to get the current week.  It calls season.getCurrentWeek.
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
      if !self.isOpen?
        if (self.changed & ["poolType", "allowMulti"]).any?
          self.errors[:poolType] << "You cannot change the Pool attributes after the first week has completed!"
        end
      end
    end

    #
    # Updates the survivor status of each surviving entry in the pool
    #
    def updateSurvivor(current_week)
      winning_teams = current_week.getWinningTeams
      self.entries.each do |entry|
        if entry.survivorStatusIn
          picks = entry.picks.where(week_number: current_week.week_number)
          picks.each do |pick|
            pick.game_picks.each do |game_pick|
              found_team = false
              winning_teams.each do |team|
                if game_pick.chosenTeamIndex == team
                  found_team = true
                end
              end
              if !found_team
                entry.update_attribute(:survivorStatusIn, false)
                entry.save
              end
            end
          end
        end
      end
      return true
    end

    def updateSUP(current_week)
    end

    def updatePickEm(current_week)
    end

    def updatePickEmSpread(current_week)
    end
end
