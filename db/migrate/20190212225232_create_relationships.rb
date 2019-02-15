class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.string :type
      t.references :user, foreign_key: true
      t.references :hotspring, foreign_key: true

      t.timestamps
      t.index [:user_id, :hotspring_id, :type], unique: true
    end
  end
end
