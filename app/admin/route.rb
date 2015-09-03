ActiveAdmin.register Route do

  menu label: '路線'

  scope :all
  scope :root, default: true
  scope :not_root

  permit_params :origin, :destination, :direction, :price, :description, :announcement, :route_map_url, :_destroy, :id, :parent_id, :is_available, :hidden, :fake_full,
    subroutes_attributes: [
      :origin,
      :destination,
      :direction,
      :price,
      :description,
      :announcement,
      :route_map_url,
      :_destroy,
      :id,
      :parent_id,
      :is_available,
      :hidden,
      :fake_full,
      # That's real nested Zzz
      schedules_attributes: [
        :departure_time,
        :route_id,
        :contact,
        :vehicle_id,
        :_destroy,
        :hidden,
        :available,
        :fake_full,
        :fake_seats,
        :fake_seats_no,
        :id,
      ]
    ]

  index do
    selectable_column
    column :id
    column :origin
    column :destination
    column :parent
    column :direction
    column :price
    column :is_available
    column :fake_full
    column :hidden
    actions
  end

  show do
    attributes_table do
      row(:id)
      row(:origin)
      row(:destination)
      row(:direction)
      row(:parent) {|rout| rout.parent && rout.parent.short_name }
      row(:price)
      row(:description)
      row(:is_available)
      row(:hidden)
      row(:fake_full)
      row(:announcement)
      row(:route_map_url)
    end

    route.subroutes.each do |subroute|
      panel "#{subroute.short_name}" do
        attributes_table_for subroute do
          row :id
          row :origin
          row :destination
          row :direction
          row :price
          row :description
          row :is_available
          row :hidden
          row :fake_full
          row :announcement
          row :route_map_url
        end

        panel '時程' do
          table_for subroute.schedules do
            column :id
            column :departure_time
            column :contact
            column :vehicle_id
            column :fake_full
            column :hidden
            column :available
            column :fake_seats
            column :fake_seats_no
            #
          end
        end # end schedule panel
      end # end subroute show panel
    end # each subroute
  end # end show

  form do |f|
    f.inputs '路線資料' do
      li 'class': 'string input optional stringish' do
        label "ID", 'class': 'label'
        para "#{f.object.id}"
      end
      f.input :origin
      f.input :destination
      f.input :parent_id, as: :select, collection: Route.root.reject{|r| r == @resource}.map {|rout| [rout.short_name, rout.id] }
      f.input :direction, as: :select, collection: %w(North South)
      f.input :price
      f.input :is_available
      f.input :hidden
      f.input :fake_full
      f.input :route_map_url
      f.input :description
      f.input :announcement
    end # end route input

    panel '子路線' do
      f.has_many :subroutes, allow_destroy: true, new_record: true do |route|
        route.input :origin
        route.input :destination
        route.input :direction, as: :select, collection: %w(North South)
        route.input :price
        route.input :is_available
        route.input :hidden
        route.input :fake_full
        route.input :description
        route.input :announcement
        route.input :route_map_url

        route.has_many :schedules, allow_destroy: true, new_record: true do |schedule|
          schedule.input :departure_time
          schedule.input :contact
          schedule.input :vehicle_id, as: :select, collection: Vehicle.all.map{|veh| ["#{veh.id}. #{veh.registration_number}, #{veh.name}:#{veh.capacity}", veh.id]}
          schedule.input :hidden
          schedule.input :available
          schedule.input :fake_full
          schedule.input :fake_seats
          schedule.input :fake_seats_no
        end
      end # end f.has_many subroutes
    end # end panel subroute

    f.actions
  end # end form
end
