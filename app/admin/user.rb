ActiveAdmin.register User do

  menu label: '使用者'

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
  permit_params do
    permitted = [:email, :username, :name, :avatar_url, :cover_photo_url, :gender, :fbid, :uid, :identity, :organization_code, :department_code]
  end


  filter(:email)
  filter(:username)
  filter(:name)
  filter(:cover_photo_url)
  filter(:gender)
  filter(:fbid)
  filter(:uid)
  filter(:identity)
  filter(:organization_code)
  filter(:department_code)

  index do
    selectable_column

    column(:id)
    column('fbid'){ |user| a user.fbid, href: "https://facebook.com/#{user.fbid}" }
    column(:email)
    column(:name)
    column(:current_sign_in_at)
    column(:sign_in_count)
    column(:created_at)

    actions
  end


end
