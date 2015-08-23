class AddColumnsToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :available, :boolean, default: false
    add_column :schedules, :hidden, :boolean, default: false
    add_column :schedules, :fake_full, :boolean, default: false
    add_column :schedules, :fake_seats, :boolean, default: false
    add_column :schedules, :fake_seats_no, :integer

    Schedule.all.each do |schedule|
      schedule.available = true
      schedule.fake_full = false
      schedule.hidden = false
      schedule.fake_seats = false
      schedule.save!
    end
  end
end
