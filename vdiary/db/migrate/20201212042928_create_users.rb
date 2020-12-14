class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest       
      t.string :name

      t.integer :entry_counter
      # HOW MANY ENTRIES HAVE BEEN CREATED by this USER : total thus far

      t.timestamps null: false
    end
  end
end
