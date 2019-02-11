class CreateDistricts < ActiveRecord::Migration[5.0]
  def change
    create_table :districts do |t|
      t.references :prefecture, foreign_key: true
      t.references :city, foreign_key: true
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
