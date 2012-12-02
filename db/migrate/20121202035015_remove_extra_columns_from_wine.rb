class RemoveExtraColumnsFromWine < ActiveRecord::Migration
  def change
  	remove_column :wines, :maker_id
  	remove_column :wines, :varietal_id
  	remove_column :wines, :region_id
  end
end
