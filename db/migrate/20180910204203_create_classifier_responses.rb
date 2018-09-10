class CreateClassifierResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :classifier_responses do |t|
      t.integer :bot_id
      t.string :text
      t.string :category
      t.timestamps
    end
  end
end
