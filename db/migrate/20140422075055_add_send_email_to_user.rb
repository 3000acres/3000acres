class AddSendEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :send_email, :boolean, :default => true
  end
end
