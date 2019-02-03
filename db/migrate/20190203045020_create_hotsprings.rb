class CreateHotsprings < ActiveRecord::Migration[5.0]
  def change
    create_table :hotsprings do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
