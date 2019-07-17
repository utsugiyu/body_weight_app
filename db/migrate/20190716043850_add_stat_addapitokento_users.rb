class AddStatAddapitokentoUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :access_token, :string, null: true
    add_column :users, :refresh_token, :string, null: true
  end
end
