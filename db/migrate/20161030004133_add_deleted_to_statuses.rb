class AddDeletedToStatuses < ActiveRecord::Migration[5.0]
  def change
    change_table :statuses do |t|
      t.change :created_at, :datetime, null: false
      t.boolean :deleted, null: false, default: false
    end
  end
end
