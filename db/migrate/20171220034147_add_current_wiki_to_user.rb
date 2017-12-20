class AddCurrentWikiToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_wiki, :id
  end
end
