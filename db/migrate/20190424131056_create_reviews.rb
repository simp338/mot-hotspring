class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true, type: :integer
      t.references :hotspring, foreign_key: true, type: :integer
      t.string :title
      t.text :comment
      t.float :review
      t.date :visit_date

      t.timestamps
    end
  end
end
