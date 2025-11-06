class Song < ApplicationRecord
  belongs_to :dataset
  has_many :questions, dependent: :destroy

  validates :genre, presence: true
  validates :filename, presence: true
  validates :relative_path, presence: true
  validates :full_path, presence: true, uniqueness: true

  scope :by_dataset, ->(dataset) { where(dataset: dataset) }
  scope :by_genre, ->(genre) { where(genre: genre) }
  scope :random, -> { order('RANDOM()') }

  def file_exists?
    File.exist?(full_path)
  end

  def audio_url
    Rails.application.routes.url_helpers.audio_serve_path(
      dataset: dataset.name.downcase,
      genre: genre,
      filename: filename
    )
  end
end

