class TasksController < ApplicationController

  def pending_bill_check_task
    if params[:key] == ENV['TASK_API_KEY']
      Bill.payment_pending.find_each do |bill|
        bill.pay_if_paid!
        bill.expire_if_deadline_passed
      end
      render json: "Task done."
    else
      render(json: "Invalid api key", status: 401)
    end
  end
end
