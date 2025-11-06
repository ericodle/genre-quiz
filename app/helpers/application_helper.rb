module ApplicationHelper
  def genre_with_chinese(genre)
    genre_map = {
      # FMA Genres
      'Blues' => '藍調',
      'Classical' => '古典',
      'Country' => '鄉村',
      'Easy Listening' => '輕音樂',
      'Electronic' => '電子',
      'Experimental' => '實驗',
      'Folk' => '民謠',
      'Hip-Hop' => '嘻哈',
      'Instrumental' => '器樂',
      'International' => '國際',
      'Jazz' => '爵士',
      'Old-Time / Historic' => '老式/歷史',
      'Pop' => '流行',
      'Rock' => '搖滾',
      'Soul-RnB' => '靈魂/R&B',
      'Spoken' => '口語',
      # GTZAN Genres
      'blues' => '藍調',
      'classical' => '古典',
      'country' => '鄉村',
      'disco' => '迪斯可',
      'hiphop' => '嘻哈',
      'jazz' => '爵士',
      'metal' => '金屬',
      'pop' => '流行',
      'reggae' => '雷鬼',
      'rock' => '搖滾'
    }
    
    chinese = genre_map[genre]
    chinese ? "#{genre} / #{chinese}" : genre
  end
end

