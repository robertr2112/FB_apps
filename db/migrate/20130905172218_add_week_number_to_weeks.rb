class AddWeekNumberToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :weekNumber, :integer
  end
end
