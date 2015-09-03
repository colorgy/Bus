class PendingBillCheckWorker
  include Sidekiq::Worker

  def perform
    Bill.payment_pending.find_each do |bill|
      bill.pay_if_paid!
      bill.expire_if_deadline_passed
    end
  end
end
