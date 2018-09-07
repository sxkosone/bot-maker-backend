class CreateClassifier < ActiveRecord::Migration[5.2]
  def change
    create_table :classifiers do |t|
      t.binary :saved
    end
  end
end
