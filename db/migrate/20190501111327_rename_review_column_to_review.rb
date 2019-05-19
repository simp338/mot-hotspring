class RenameReviewColumnToReview < ActiveRecord::Migration[5.1]
  def change
    rename_column :reviews, :review, :satisfaction_degree
  end
end
