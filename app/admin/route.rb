ActiveAdmin.register Route do

  permit_params :origin, :destination, :direction, :price, :description, :announcement, :route_map_url, :_destroy, :id, :parent_id,
    schedules_attributes: [
      :departure_time,
      :route_id,
      :contact,
      :vehicle_id,
      :_destroy,
      :id,
    ]

  index do
    selectable_column
    column :id
    column :origin
    column :destination
    column :direction
    column :price
    column :route_map_url
    actions
  end

  show do
    attributes_table do
      row(:origin)
      row(:destination)
      row(:direction)
      row(:price)
      row(:description)
      row(:announcement)
      row(:route_map_url)
      row(:parent) {|rout| rout.parent && rout.parent.short_name }
    end

    panel '時程' do
      table_for route.schedules do
        column :departure_time
        column :contact
        column :vehicle_id
        #
      end
      active_admin_comments
    end
  end

  form do |f|
    f.inputs '路線資料' do
      f.input :origin
      f.input :destination
      f.input :direction, as: :select, collection: %w(North South)
      f.input :price
      f.input :description
      f.input :announcement
      f.input :route_map_url
      f.input :parent_id, as: :select, collection: Route.root.reject{|r| r == @resource}.map {|rout| [rout.short_name, rout.id] }
    end # end route input

    panel '子路線' do
      f.has_many :subroutes, allow_destroy: true, new_record: true do |route|
        route.input :origin
        route.input :destination
        route.input :direction, as: :select, collection: %w(North South)
        route.input :price
        route.input :description
        route.input :announcement
        route.input :route_map_url
      end
    end

    panel '時程設定' do
      f.has_many :schedules, allow_destroy: true, new_record: true do |schedule|
        schedule.input :departure_time
        schedule.input :contact
        schedule.input :vehicle_id, as: :select, collection: Vehicle.all.map{|veh| ["#{veh.id}. #{veh.registration_number}, #{veh.name}:#{veh.capacity}", veh.id]}
      end
    end # end schedule panel
    f.actions
  end # end form
end
