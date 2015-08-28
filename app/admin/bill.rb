ActiveAdmin.register Bill do
  menu priority: 119, label: '帳單'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  index do
    selectable_column
    column(:id)
    column(:user_id) { |bill| a bill.user.name, href: admin_user_path(bill.user) }
    column(:price)
    column(:amount)
    column(:invoice_type)
    column(:type)
    column(:state) { |bill| status_tag bill.state }
    column(:payment_code)
    column(:virtual_account)
    column(:paid_at)
    column(:used_credits)
    column(:deadline)
    column(:created_at)
    column(:updated_at)
    actions
  end
end
