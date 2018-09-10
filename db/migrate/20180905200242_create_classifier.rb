class CreateClassifier < ActiveRecord::Migration[5.2]
  def change
    create_table :classifiers do |t|
      t.binary :saved
      t.integer :bot_id
      t.string :category_1
      t.string :category_2
      
      t.text :data_1
      t.text :data_2
    end
  end
end
