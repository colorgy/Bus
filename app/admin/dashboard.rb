ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        Route.not_root.where(hidden: false).each do |subroute|
          root_route = subroute.parent

          panel(link_to(subroute.short_name, admin_route_path(subroute)) )do
            table do
              thead do
                tr do
                  %w(ID 時間 剩餘座位 已付款 待付款).each(&method(:th))
                end
              end

              subroute.schedules.each do |schedule|
                tr do
                  td { a schedule.id, href: admin_route_path(root_route) }
                  td schedule.departure_time.strftime('%Y/%m/%d %H:%M')
                  td schedule.available_seats_count

                  td do
                    a Order.paid.where(schedule: schedule).count, href: admin_orders_path('q[schedule_id_equals]': schedule.id, 'q[state_equals]': :paid)
                  end

                  td do
                    a Order.payment_pending.where(schedule: schedule).count, href: admin_orders_path('q[schedule_id_equals]': schedule.id, 'q[state_equals]': :payment_pending)
                  end
                end
              end

            end
          end
        end
      end

      column do
        panel( link_to('Recent Bills', admin_bills_path) ) do
          table do
            thead do
              tr do
                %w(id user amount state paid_at created_at).each(&method(:th))
              end
            end

            tbody do
              Bill.order('id desc').first(20).map do |bill|
                tr do
                  td { a bill.id, href: admin_bill_path(bill) }
                  td { a bill.user.name, href: admin_user_path(bill.user) }
                  td bill.amount
                  td do
                    tag = nil
                    case bill.state
                    when "paid"
                      tag = :ok
                    when "payment_pending"
                      tag = :warning
                    end
                    tag.nil? ? status_tag(bill.state) : status_tag(bill.state, tag)
                  end
                  td bill.paid_at
                  td bill.created_at
                end
              end
            end
          end
        end

        panel 'Recent Order' do
          table do
            thead do
              tr do
                %w(id user price state created_at).each(&method(:th))
              end
            end

            tbody do
              Order.order('id desc').first(20).map do |order|
                tr do
                  td { a order.id, href: admin_order_path(order) }
                  td { a order.user.name, href: admin_user_path(order.user) }
                  td order.price
                  td do
                    tag = nil
                    case order.state
                    when "paid"
                      tag = :ok
                    when "new"
                      tag = :warning
                    when "payment_pending"
                      tag = :warning
                    end
                    tag.nil? ? status_tag(order.state) : status_tag(order.state, tag)
                  end
                  td order.created_at
                end
              end
            end
          end
        end
      end

    end

  end # content
end
