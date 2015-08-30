class UserMailer < ActionMailer::Base
  default from: ENV['MAILER_SENDER']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_ticket.subject
  #
  def send_ticket(user, bill)
    @user = user
    @bill = bill
    @orders = bill.orders
    @order = @orders.first

    mail to: user.email
  end
end
