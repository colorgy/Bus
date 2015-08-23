module RoutesHelper
  def render_schedule_radio schedule
    classes = {
      requrie: ''
    }.merge((schedule.is_available? && schedule.available?) ?  {} : {disabled: ''})

    radio_button("schedule", "id", schedule.id, classes)
  end

  def render_available_seats schedule, user: nil
    if schedule.is_full?
      "班次已售完！"
    else
      seat_count = schedule.is_faked? ? schedule.fake_seats_no : schedule.available_seats_count
      unless user.nil?
        # 真真假假，假假真真
        seat_count -= user.orders.where(schedule: schedule).count
        seat_count = 0 if seat_count < 0
      end
      "還剩 #{seat_count} 位"
    end
  end
end
