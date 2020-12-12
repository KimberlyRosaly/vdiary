class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :message
      # CHARACTER CONTRAINTS : STRING - 1-255 | TEXT - 1-65536
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
