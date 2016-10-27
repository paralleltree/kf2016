class CreateMedia < ActiveRecord::Migration[5.0]
  def change
    create_table :media, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY'
      t.column :status_id, 'BIGINT NOT NULL'
      t.string :url, null: false
      t.timestamps null: false

      t.index :status_id
    end
  end
end
