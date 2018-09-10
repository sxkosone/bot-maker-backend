class AddBotIdToClassifiers < ActiveRecord::Migration[5.2]
  def change
    add_column :classifiers, :bot_id, :integer
    add_column :classifiers, :category_1, :string
    add_column :classifiers, :category_2, :string
    add_column :classifiers, :data_1, :text
    add_column :classifiers, :data_2, :text
  end
end
