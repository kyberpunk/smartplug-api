class CreateHome < ActiveRecord::Migration[5.1]
  def change
    create_table :homes do |t|
      t.string :name, null: false
      t.string :apartment
      t.string :city
      t.string :street
      t.string :zipCode
      t.string :countyCode
      t.string :state
      t.decimal :tariffPrice
    end
  end
end
