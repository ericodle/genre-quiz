class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.integer :question_number, null: false
      t.datetime :presented_at
      t.datetime :answered_at
      t.float :time_spent_seconds

      t.timestamps
    end

    add_index :questions, [:quiz_id, :question_number]
  end
end

