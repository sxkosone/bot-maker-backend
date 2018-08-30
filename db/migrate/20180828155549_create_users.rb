class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest, null: false
      t.string :bot_name
      t.string :bot_url_id
      t.timestamps
    end
  end
end
