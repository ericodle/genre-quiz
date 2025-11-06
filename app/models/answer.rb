class Answer < ApplicationRecord
  belongs_to :question
  has_one :quiz, through: :question
  has_one :song, through: :question

  validates :selected_genre, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
  validates :confidence, inclusion: { in: 1..5 }, allow_nil: true
end

