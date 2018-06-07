class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :num
      t.string :position
      t.string :category
      t.string :skuid
      t.string :prd_id
      t.string :name
      t.string :brand
      t.integer :price
      t.string :link_com_1
      t.string :link_com_2
      t.string :link_com_3
      t.string :link_com_4
      t.string :link_com_5
      t.string :link_com_6

      t.timestamps
    end
  end
end
