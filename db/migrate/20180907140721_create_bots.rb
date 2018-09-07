class CreateBots < ActiveRecord::Migration[5.2]
  def change
    create_table :bots do |t|
      t.string :name
      t.string :url_id
      t.integer :user_id
      t.boolean :include_default_scripts
      t.string :description
    end
  end
end
