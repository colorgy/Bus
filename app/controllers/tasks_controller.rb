require 'csv'

class TasksController < ApplicationController
  before_action :authenticate_admin_user!, only: :bill_export

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

  def bill_export
    filename = Rails.root.join('tmp', "bus_bills_#{Time.now.strftime('%Y-%m-%d-%H_%M_%S')}.csv")
    CSV.open(filename, 'w') do |csv|
      csv << %w(訂票人 狀態 路線 時間 張數 取票人 取票人email 取票人手機 取票人身份證)

      Bill.paid.each do |bill|
        order = bill.orders.first
        next if order.schedule.nil?
        dept_time = order.schedule.departure_time.strftime('%Y/%m/%d %H:%M')
        csv << [bill.user.name, bill.state, order.schedule.route.short_name, dept_time, bill.orders_count, order.receiver_name, order.receiver_email, order.receiver_phone, order.receiver_identity_number]
      end

      Bill.payment_pending.each do |bill|
        order = bill.orders.first
        dept_time = order.schedule.departure_time.strftime('%Y/%m/%d %H:%M')
        csv << [bill.user.name, bill.state, order.schedule.route.short_name, dept_time, bill.orders_count, order.receiver_name, order.receiver_email, order.receiver_phone, order.receiver_identity_number]
      end
    end

    send_file filename
  end

end
