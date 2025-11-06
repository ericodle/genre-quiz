class User < ApplicationRecord
  has_many :quizzes, dependent: :destroy

  validates :name, presence: true
  validates :date_of_test, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end

