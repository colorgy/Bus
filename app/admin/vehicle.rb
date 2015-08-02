ActiveAdmin.register Vehicle do

  permit_params :capacity, :description, :seat_info, :registration_number, :name,
    schedules_attributes: [
      :departure_time,
      :route_id,
      :contact,
      :vehicle_id
    ],
    seats_attributes: [
      :vehicle_id,
      :priority,
      :row_no,
      :seat_no
    ]

  index do
    selectable_column
    column :id
    column :name
    column :capacity
    column :seat_info
    column :registration_number
    actions
  end

  show do
    attributes_table do
      row :name
      row :capacity
      row :description
      row :seat_info
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
      f.input :capacity
      f.input :description
      f.input :seat_info
      f.input :registration_number
    end

    panel '座位表' do
      f.has_many :seats, allow_destroy: true, new_record: true do |seat|
        seat.input :vehicle_id, as: :select, collection: Vehicle.all.map{|veh| [veh.capacity, veh.id]}
        seat.input :priority
        seat.input :row_no
        seat.input :seat_no
      end
    end

    panel '時程設定' do
      f.has_many :schedules, allow_destroy: true, new_record: true do |schedule|
        schedule.input :departure_time
        schedule.input :contact
        schedule.input :vehicle_id, as: :select, collection: Vehicle.all.map{|veh| [veh.capacity, veh.id]}
      end
    end

  end

end
