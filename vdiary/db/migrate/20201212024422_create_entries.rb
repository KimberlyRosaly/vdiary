class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :message
      # CHARACTER CONTRAINTS : STRING - 1-255 | TEXT - 1-65536

      t.integer :user_id
      # FOREIGN KEY for the USER RELATIONSHIP

      t.integer :number
      # KEEP TRACK : NUMBER OF CREATED ENTRY : USER HAS A TOTAL NUMBER OF ENTRIES

      t.timestamps null: false
    end
  end
end
