class AddDepartureTimeToRouteRequests < ActiveRecord::Migration
  def change
    add_column :route_requests, :departure_time, :datetime
  end
end
