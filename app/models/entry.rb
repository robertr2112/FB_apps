class Entry < ActiveRecord::Base

  belongs_to :week
  has_many :game_picks, dependent: :destroy

  accepts_nested_attributes_for :game_picks

  def setUserId(user)
    self.user_id = user.id
    self.save
  end

end
