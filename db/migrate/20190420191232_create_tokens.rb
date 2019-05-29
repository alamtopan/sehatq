class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.text :token
      t.string :kind
      t.date :expiry_date
      t.integer :user_id

      t.timestamps
    end

    add_index :tokens, :user_id
  end
end
