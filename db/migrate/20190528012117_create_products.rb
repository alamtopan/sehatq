class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :slug
      t.string :title
      t.string :category
      t.float :price
      t.string :cover_image
      t.text :description
      t.integer :stock, default: 0

      t.timestamps
    end
  end
end
