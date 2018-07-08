class CreatePersonMetaData < ActiveRecord::Migration[5.1]
  def change
    create_table :person_meta_data do |t|
      t.datetime :last_cached_at

      t.timestamps null: false
    end
  end
end
