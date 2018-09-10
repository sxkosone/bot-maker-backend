class AddClassifierToBots < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :include_classifier, :boolean
  end
end
