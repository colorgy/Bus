module SchedulesHelper
  def seat_label_for (seat)
    content_tag('label', seat.seat_no, 'for' => "vehicle_seats_#{seat.id}")
  end
end
