class CreateTriggers < ActiveRecord::Migration[5.2]
  def change
    create_table :triggers do |t|
      t.integer :user_id
      t.string :text
      t.timestamps
    end
  end
end
