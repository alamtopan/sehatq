class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slug
      t.string :full_name
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :avatar

      t.timestamps
    end
  end
end
