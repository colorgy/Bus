ActiveAdmin.register_page "Setting" do

  content do
    form :action => admin_settings_update_path, :method => :post do |f|
      f.input :name => 'authenticity_token', :type => :hidden, :value => form_authenticity_token.to_s

        # Settings form helper methods

        def f.input_setting(label_text, settings_name, hint: nil)
          label label_text
          input :name => "settings[#{settings_name.to_s}]", :type => 'text', :value => Settings[settings_name]
          if hint.present?
            para class: 'inline-hints' do
              hint
            end
          end
        end

        def f.textarea_setting(label_text, settings_name, hint: nil)
          label label_text
          textarea :name => "settings[#{settings_name.to_s}]" do
            Settings[settings_name]
          end
          if hint.present?
            para class: 'inline-hints' do
              hint
            end
          end
        end

        def f.checkbox_setting(label_text, settings_name, hint: nil)
          label label_text
          input :id => "cb-#{settings_name}", :type => 'checkbox', :onchange => "if (this.checked) { document.getElementById('ip-#{settings_name}').value = 'true'; } else { document.getElementById('ip-#{settings_name}').value = 'false'; }", :onload => "alert('aa')", "#{Settings[settings_name] ? 'checked' : 'not_checked'}" => 'checked'
          input :name => "settings[#{settings_name}]", :id => "ip-#{settings_name}", :type => 'hidden'
          script type: 'text/javascript' do
            "$('#cb-#{settings_name}').change();".html_safe
          end
          if hint.present?
            para class: 'inline-hints' do
              hint
            end
          end
        end

        # Settings form

        panel "System Settings" do
          fieldset do
            ol do
              li do
                f.checkbox_setting '使用者條款', 'user_agreement'
              end

            end
          end
        end
    end
  end

end
