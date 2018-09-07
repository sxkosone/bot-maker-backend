class CreateClassifier < ActiveRecord::Migration[5.2]
  def change
    create_table :classifiers do |t|
      t.text :classifier
    end
  end
end
