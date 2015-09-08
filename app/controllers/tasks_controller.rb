require 'csv'

class TasksController < ApplicationController
  before_action :authenticate_admin_user!, only: [:bill_export, :invoice_export]

  def pending_bill_check_task
    if params[:key] == ENV['TASK_API_KEY']
      Bill.payment_pending.find_each do |bill|
        bill.pay_if_paid!
        bill.expire_if_deadline_passed

        if bill.paid?
          UserMailer.delay.send_ticket(bill.user, bill)
          UserMailer.delay.send_ticket(bill.user, bill, ENV['REPORT_MAIL'])
          bill.mail_sent_at = Time.now
          bill.save!
        elsif bill.expired?
          UserMailer.delay.notify_expired(bill.user, bill)
          bill.mail_sent_at = Time.now
          bill.save!
        end
      end
      render json: "Task done."
    else
      render(json: "Invalid api key", status: 401)
    end
  end

  def bill_export
    filename = Rails.root.join('tmp', "bus_bills_#{Time.now.strftime('%Y-%m-%d-%H_%M_%S')}.csv")
    CSV.open(filename, 'w') do |csv|
      csv << %w(訂票人 狀態 學校 FB 路線 時間 張數 取票人 取票人email 取票人手機 取票人身份證)

      Bill.paid.each do |bill|
        order = bill.orders.first
        next if order.schedule.nil?
        dept_time = order.schedule.departure_time.strftime('%Y/%m/%d %H:%M')
        csv << [
          bill.user.name,
          bill.state,
          bill.user.organization_code,
          bill.user.fbid && "https://facebook.com/#{bill.user.fbid}",
          order.schedule.route.short_name,
          dept_time,
          bill.orders_count,
          bill.receiver_name,
          bill.receiver_email,
          bill.receiver_phone,
          bill.receiver_identity_number
        ]
      end

      Bill.payment_pending.each do |bill|
        order = bill.orders.first
        dept_time = order.schedule.departure_time.strftime('%Y/%m/%d %H:%M')
        csv << [
          bill.user.name,
          bill.state,
          bill.user.organization_code,
          bill.user.fbid && "https://facebook.com/#{bill.user.fbid}",
          order.schedule.route.short_name,
          dept_time,
          bill.orders_count,
          bill.receiver_name,
          bill.receiver_email,
          bill.receiver_phone,
          bill.receiver_identity_number
        ]
      end
    end

    send_file filename
  end

  def invoice_export
    header_row = %w{發票張數 發票日期 品名序號 發票品名 數量 單價 課稅別 稅率 通關方式 買方統編 列印+Email 手機條碼 自然人 愛心碼 會員類別 會員號碼 貨號 國際條碼 發票備註欄位 交易明細備註欄位}

    file_basename = "#{Time.now.strftime('%F %T')}.xls"
    fn = Rails.root.join('tmp', file_basename)

    exported_lines = Bill.where(state: :paid).order(amount: :desc).each.with_index.inject([]) do |lines, (bill, bill_index)|

      order = bill.orders.first
      order.schedule.formatted_departure_time

      lines << [
        bill_index+1, # serial
        Date.today.to_s, # 發票日期
        1, # 品名序號，在 Bus 每張 bill 只會有一種 schedule，所以 1
        "#{order.schedule.route.short_name} #{order.schedule.formatted_departure_time}", # 發票品名
        bill.orders_count, # 數量
        order.price, # 單價
        "1", # 課稅別
        "0.05", # 稅率
        "", # 通關方式
        bill.invoice_uni_num,
        "", # 列印+Email
        bill.invoice_code, # 手機條碼
        bill.invoice_cert, # 自然人
        bill.invoice_love_code, # 愛心碼
        ENV['GATEWAY_ACCOUNT_TYPE'], # 會員類別
        bill.user.id, # 會員號碼
        "", # 貨號
        "", # 國際條碼
        bill.user.name, # 發票備註欄位
        bill.id, # 交易明細備註欄位
      ]

      # 金流手續費
      if bill.amount > bill.price
        fees = bill.amount - bill.price

        lines << [
          bill_index+1, # serial
          Date.today.to_s, # 發票日期
          2, # 品名序號，在 Bus 手續費必為第二張，所以 2
          "金流手續費", # 發票品名
          1, # 數量
          fees, # 單價
          "1", # 課稅別
          "0.05", # 稅率
          "", # 通關方式
          bill.invoice_uni_num,
          "", # 列印+Email
          bill.invoice_code, # 手機條碼
          bill.invoice_cert, # 自然人
          bill.invoice_love_code, # 愛心碼
          ENV['GATEWAY_ACCOUNT_TYPE'], # 會員類別
          bill.user.id, # 會員號碼
          "", # 貨號
          "", # 國際條碼
          bill.user.name, # 發票備註欄位
          bill.id, # 交易明細備註欄位
        ]
      end

      lines
    end

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).concat(header_row)
    exported_lines.each_with_index { |l, i| sheet.row(i+1).concat(l) }
    book.write fn

    send_file fn
  end

end
