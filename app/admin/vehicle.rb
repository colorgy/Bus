ActiveAdmin.register Vehicle do

  menu label: '客運'

  permit_params :capacity, :description, :seat_info_string,
                :registration_number, :name, :_destroy, :id,
    schedules_attributes: [
      :departure_time,
      :departure_time_date,
      :departure_time_time_hour,
      :departure_time_time_minute,
      :route_id,
      :contact,
      :vehicle_id,
      :_destroy,
      :id,
    ],
    seats_attributes: [
      :vehicle_id,
      :priority,
      :row_no,
      :seat_no,
      :_destroy,
      :id
    ]

  index do
    selectable_column
    column :id
    column :name
    column :capacity
    column :registration_number
    actions
  end

  show do
    attributes_table do
      row :name
      row :capacity
      row :description
      row :seat_info_string
      row :registration_number
    end

    panel '座位表' do
      table_for vehicle.seats do
        column :vehicle_id
        column :priority
        column :row_no
        column :seat_no
      end
    end

    panel '時程' do
      table_for vehicle.schedules do
        column :departure_time
        column :contact
      end
    end
  end # end show

  form do |f|
    f.inputs '客運資料' do
      f.input :name
      f.input :capacity
      f.input :description
      f.input :seat_info_string, as: :text
      f.input :registration_number
    end

    # panel '座位表' do
    #   f.has_many :seats, allow_destroy: true, new_record: true do |seat|
    #     # seat.input :vehicle_id, as: :select, collection: Vehicle.all.map{|veh| ["#{veh.id}: #{veh.name}", veh.id]}
    #     seat.input :vehicle_id, input_html: { value: vehicle.id }, as: :hidden
    #     seat.input :priority
    #     seat.input :row_no
    #     seat.input :seat_no
    #   end
    # end

    panel '時程設定' do
      f.has_many :schedules, allow_destroy: true, new_record: true do |schedule|
        schedule.input :departure_time
        schedule.input :contact
        schedule.input :vehicle_id, as: :select, collection: Vehicle.all.map{|veh| ["#{veh.id}. #{veh.registration_number}, #{veh.name}:#{veh.capacity}", veh.id]}
      end
    end

    f.actions
  end

end
