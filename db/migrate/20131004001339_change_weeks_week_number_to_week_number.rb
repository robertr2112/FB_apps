class ChangeWeeksWeekNumberToWeekNumber < ActiveRecord::Migration
  def change
    rename_column :weeks, :weekNumber, :week_number
  end
end
