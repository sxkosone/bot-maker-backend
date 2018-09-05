class AddIncludeDefaultScriptsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :include_default_scripts, :boolean
  end
end
