class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
        t.belongs_to :wiki, index: true
        t.belongs_to :user, index: true
      
      t.timestamps null: false
    end
    
    add_index :collaborators, :id, unique: true
  end
end
