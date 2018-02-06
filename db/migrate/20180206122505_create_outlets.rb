class CreateOutlets < ActiveRecord::Migration[5.1]
  def change
    create_table :outlets do |t|
      t.string :name, null: false
      t.string :device_id, null: false
      t.integer :home_id, null: false
      t.integer :appliance_id
    end
  end
end
