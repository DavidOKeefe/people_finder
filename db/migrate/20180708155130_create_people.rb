class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.integer :sales_loft_id, null: false
      t.string :email
      t.string :full_name
      t.string :title

      t.timestamps null: false
    end
  end
end
