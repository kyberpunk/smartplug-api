class CreateHomes < ActiveRecord::Migration[5.1]
  def change
    create_table :homes do |t|
      t.string :name, null: false
      t.string :apartment
      t.string :city
      t.string :street
      t.string :zip_code
      t.string :country_code
      t.integer :user_id, null: false
    end
  end
end
