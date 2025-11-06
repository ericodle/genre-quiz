class Dataset < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :quizzes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :base_path, presence: true

  FMA_GENRES = [
    'Blues', 'Classical', 'Country', 'Easy Listening', 'Electronic',
    'Experimental', 'Folk', 'Hip-Hop', 'Instrumental', 'International',
    'Jazz', 'Old-Time / Historic', 'Pop', 'Rock', 'Soul-RnB', 'Spoken'
  ].freeze

  GTZAN_GENRES = [
    'blues', 'classical', 'country', 'disco', 'hiphop',
    'jazz', 'metal', 'pop', 'reggae', 'rock'
  ].freeze

  def fma?
    name == 'FMA'
  end

  def gtzan?
    name == 'GTZAN'
  end

  def genre_list
    genres.is_a?(Array) ? genres : []
  end
end

