class ExpiredBillCheckWorker
  include Sidekiq::Worker

  def perform
    Bill.expired.find_each do |bill|
      bill.destroy
    end
  end
end
