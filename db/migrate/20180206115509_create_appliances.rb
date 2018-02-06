class CreateAppliances < ActiveRecord::Migration[5.1]
  def change
    create_table :appliances do |t|
      t.string :name, null: false
      t.string :appliance_type
      t.integer :home_id, null: false
    end
  end
end
