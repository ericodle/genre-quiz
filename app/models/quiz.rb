class Quiz < ApplicationRecord
  belongs_to :dataset
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :songs, through: :questions
  has_many :answers, through: :questions

  validates :session_id, presence: true, uniqueness: true
  validates :total_questions, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[in_progress completed abandoned] }

  before_validation :generate_session_id, on: :create
  before_create :set_started_at

  scope :in_progress, -> { where(status: 'in_progress') }
  scope :completed, -> { where(status: 'completed') }

  def current_question
    questions.order(:question_number).find_by(answered_at: nil)
  end

  def current_question_number
    answered_questions_count + 1
  end

  def answered_questions_count
    questions.where.not(answered_at: nil).count
  end

  def completed?
    status == 'completed'
  end

  def complete!
    update(status: 'completed', completed_at: Time.current)
  end

  def total_correct
    answers.where(is_correct: true).count
  end

  def accuracy
    return 0.0 if total_questions.zero?
    (total_correct.to_f / total_questions) * 100
  end

  def results_by_genre
    answers.joins(question: :song)
           .group('songs.genre')
           .select('songs.genre, COUNT(*) as total, SUM(CASE WHEN answers.is_correct THEN 1 ELSE 0 END) as correct')
           .map do |result|
             total = result.total.to_i
             correct = result.correct.to_i
             {
               genre: result.genre,
               total: total,
               correct: correct,
               accuracy: total > 0 ? (correct.to_f / total * 100) : 0.0
             }
           end
  end

  private

  def generate_session_id
    self.session_id ||= SecureRandom.hex(16)
  end

  def set_started_at
    self.started_at ||= Time.current
  end
end

