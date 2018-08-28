class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.integer :trigger_id
      t.string :text
      t.timestamps
    end
  end
end
