# == Schema Information
#
# Table name: entries
#
#  id               :integer          not null, primary key
#  pool_id          :integer
#  user_id          :integer
#  name             :string(255)
#  survivorStatusIn :boolean          default(TRUE)
#  supTotalPoints   :integer          default(0)
#  created_at       :datetime
#  updated_at       :datetime
#

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
  
  # !!!! Is this the right place for this routine?  If so, then need to modify this routine and update all views that call it.
  def madePicks?(entry)
    picks = self.picks.where(entry_id: entry.id)
    picks.each do |pick|
      if (pick.entry_id == entry.id && pick.weekNumber == self.week_number)
        return true
      end
    end
    return false
  end

end
