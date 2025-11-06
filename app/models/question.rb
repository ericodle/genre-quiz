class Question < ApplicationRecord
  belongs_to :quiz
  belongs_to :song
  has_one :answer, dependent: :destroy

  validates :question_number, presence: true, uniqueness: { scope: :quiz_id }
  validates :question_number, numericality: { greater_than: 0 }

  scope :answered, -> { where.not(answered_at: nil) }
  scope :unanswered, -> { where(answered_at: nil) }
  scope :ordered, -> { order(:question_number) }

  before_create :set_presented_at

  def answered?
    answered_at.present?
  end

  def answer_question!(selected_genre, confidence: nil)
    is_correct = selected_genre == song.genre
    time_spent = presented_at ? (Time.current - presented_at) : nil

    transaction do
      update(
        answered_at: Time.current,
        time_spent_seconds: time_spent
      )

      create_answer!(
        selected_genre: selected_genre,
        is_correct: is_correct,
        confidence: confidence
      )
    end
  end

  private

  def set_presented_at
    self.presented_at ||= Time.current
  end
end

