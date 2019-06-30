class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.float :weight
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :records, [:user_id, :created_at]
  end
end
