class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY'
      t.string :screen_name, null: false
      t.string :name, null: false
      t.string :profile_image_url, null: false
      t.timestamps null: false
    end
  end
end
