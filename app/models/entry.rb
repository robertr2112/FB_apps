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
end
