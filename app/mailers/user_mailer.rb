class UserMailer < ActionMailer::Base
  default from: ['"', ENV['MAILER_NAME'], '"', " <#{ENV['MAILER_SENDER']}>"].join
  layout 'mail_layout'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_ticket.subject
  #
  def send_ticket(user, bill, mail_address=nil, subject=nil)
    @user = user
    @bill = bill
    @orders = bill.orders

    email_address = mail_address || @bill.receiver_email || user.email
    subj = subject || 'Colorgy Bus 付款成功通知'

    mail to: email_address, subject: subj
  end

  def notify_expired(user, bill, mail_address=nil, subject=nil)
    @user = user
    @bill = bill
    @orders = bill.orders

    email_address = mail_address || @bill.receiver_email || user.email
    subj = subject || 'Colorgy Bus 訂票繳費過期'

    mail to: email_address, subject: subj
  end
end
