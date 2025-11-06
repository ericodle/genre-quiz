class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true, index: false
      t.string :selected_genre, null: false
      t.boolean :is_correct, null: false
      t.integer :confidence

      t.timestamps
    end

    add_index :answers, :question_id, unique: true
  end
end

