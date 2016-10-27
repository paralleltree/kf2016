class CreateStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY'
      t.column :user_id, 'BIGINT NOT NULL'
      t.string :text, null: false
      t.string :url, null: false
      t.timestamps null: false

      t.index :user_id
    end
  end
end
