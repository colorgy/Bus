require "factory_girl"

namespace :dev do
  desc "Seed data for development environment"
  task prime: "db:setup" do

    if Rails.env.development? || ENV['STAGING'].present?
      include FactoryGirl::Syntax::Methods

      create(:admin_user, username: 'admin', email: 'admin@dev.tw', password: 'password', password_confirmation: 'password')

      5.times do
        route = create(:route)
        sub_route = create(:route, parent: route)
        Random.rand(1..3).times do
          create(:schedule, route: sub_route)
        end
      end

      # 10.times { Schedule.first.vehicle.seats << create(:seat) }

    end
  end
end
