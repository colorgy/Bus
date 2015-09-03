class AddMailSentAtColumnToBills < ActiveRecord::Migration
  def change
    add_column :bills, :mail_sent_at, :datetime
  end
end
