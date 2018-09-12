class CreateFallbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :fallbacks do |t|
      t.string :text
      t.integer :bot_id

      t.timestamps
    end
  end
end
