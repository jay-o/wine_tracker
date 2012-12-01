class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :name
      t.text :description
      t.integer :maker_id
      t.integer :region_id
      t.integer :varietal_id
      t.integer :year

      t.timestamps
    end
  end
end
