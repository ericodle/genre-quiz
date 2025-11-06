class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :session_id, null: false
      t.references :dataset, null: false, foreign_key: true
      t.string :status, default: 'in_progress'
      t.integer :total_questions, null: false
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :quizzes, :session_id, unique: true
    add_index :quizzes, :status
  end
end

