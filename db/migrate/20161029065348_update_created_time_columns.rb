class UpdateCreatedTimeColumns < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.remove :created_at
      t.remove :updated_at
      t.datetime :created_at
    end

    change_table :statuses do |t|
      t.remove :created_at
      t.remove :updated_at
      t.datetime :created_at
    end

    change_table :media do |t|
      t.remove :created_at
      t.remove :updated_at
    end
  end
end
