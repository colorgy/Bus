class Vehicle < ActiveRecord::Base
  after_update :check_seats

  has_many :schedules
  has_many :orders
  has_many :seats

  accepts_nested_attributes_for :schedules, :seats, allow_destroy: true

  store :seat_info, accessors: [:row, :column, :seating], coder: JSON

  def seat_info_string
    self.seat_info.to_s
  end

  def seat_info_string=(string)
    self.seat_info = JSON.parse(string)
  end

  def mapped_seats
    self.seat_info[:seating] && self.seat_info[:seating].map {|row|
      row.map { |seat_no|
        seat_no && self.seats.find_by(seat_no: seat_no)
      }
    } || []
  end

  # seat_info_string = {
  #   "seating": [
  #     [ "1",  "2", null, null],
  #     [ "3",  "4", null,  "5"],
  #     [ "6",  "7", null,  "8"],
  #     [ "9", "10", null, "11"],
  #     ["14", "13", null, "12"],
  #     [null, null, null, "15"],
  #     ["16", "17", null, "18"],
  #     ["19", "20", null, "21"],
  #     ["22", "23", null, "24"],
  #     ["25", "26", null, "27"],
  #     ["28", "29", "30", "31"]
  #   ]
  # }
  private
    def check_seats
      return unless self.seat_info_changed?
      return unless self.seat_info[:seating] && self.seat_info[:seating].is_a?(Array)

      Seat.destroy_all(vehicle: self)
      # may need to handle orders

      i = 1
      self.seat_info[:seating].each_with_index do |seat_row, row_no|
        seat_row.each do |seat_no|
          next if seat_no.nil?

          self.seats << Seat.create!(priority: i, row_no: row_no, seat_no: seat_no)
          i += 1
        end
      end
    end
end
