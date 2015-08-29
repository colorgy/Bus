require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

require 'clockwork'

module Clockwork
  configure do |config|
    config[:logger] = Rails.logger
  end

  every(10.minutes, 'bill.check_pay') { PendingBillCheckWorker.perform_async }
  every(6.hours, 'bill.check_expire') { ExpiredBillCheckWorker.perform_async }
end
