class Entry < ActiveRecord::Base
  belongs_to :pool
  belongs_to :user
  has_many   :picks, dependent: :destroy

  def entryStatusGood?
    if self.survivorStatusIn 
      return true
    else
      return false
    end
  end
end
