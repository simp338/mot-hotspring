class AddColumnToHotsprings < ActiveRecord::Migration[5.0]
  def change
    add_column :hotsprings, :image_url, :string
  end
end
