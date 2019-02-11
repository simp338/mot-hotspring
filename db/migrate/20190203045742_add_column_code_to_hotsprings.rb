class AddColumnCodeToHotsprings < ActiveRecord::Migration[5.0]
  def change
    add_column :hotsprings, :code, :string
  end
end
