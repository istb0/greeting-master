class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.string  :comment, limit: 255, null: false
      t.integer :max_score, null: false
      t.integer :emotion_type, default: 0, null: false

      t.timestamps
    end
  end
end
