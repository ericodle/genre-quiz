require 'set'

namespace :audio do
  desc "Seed audio files from mounted volumes"
  task seed: :environment do
    puts "Starting audio file seeding..."

    # FMA Dataset
    fma_base_path = ENV.fetch('AUDIO_FMA_BASE_PATH', '/app/audio/fma-test')
    if Dir.exist?(fma_base_path)
      puts "Processing FMA dataset from #{fma_base_path}..."
      seed_dataset('FMA', fma_base_path, Dataset::FMA_GENRES)
    else
      puts "Warning: FMA base path #{fma_base_path} does not exist"
    end

    # GTZAN Dataset
    gtzan_base_path = ENV.fetch('AUDIO_GTZAN_BASE_PATH', '/app/audio/gtzan-test')
    if Dir.exist?(gtzan_base_path)
      puts "Processing GTZAN dataset from #{gtzan_base_path}..."
      seed_dataset('GTZAN', gtzan_base_path, Dataset::GTZAN_GENRES)
    else
      puts "Warning: GTZAN base path #{gtzan_base_path} does not exist"
    end

    puts "Audio file seeding completed!"
  end

  desc "Clear all audio file records"
  task clear: :environment do
    puts "Clearing all audio file records..."
    Song.destroy_all
    Dataset.destroy_all
    puts "All audio file records cleared!"
  end

  private

  def seed_dataset(name, base_path, expected_genres)
    dataset = Dataset.find_or_create_by(name: name) do |d|
      d.base_path = base_path
      d.description = "#{name} test set for music genre classification"
      d.genres = expected_genres
    end

    # Update base_path if it changed
    dataset.update(base_path: base_path) if dataset.base_path != base_path

    songs_count = 0
    genres_found = Set.new

    # Scan directory structure
    Dir.glob(File.join(base_path, '**', '*')).each do |file_path|
      next unless File.file?(file_path)
      next unless ['.mp3', '.wav'].include?(File.extname(file_path).downcase)

      relative_path = Pathname.new(file_path).relative_path_from(Pathname.new(base_path)).to_s
      filename = File.basename(file_path)
      
      # Extract genre from directory structure
      # FMA: base_path/Blues/001042.mp3
      # GTZAN: base_path/blues/blues.00000.wav
      path_parts = relative_path.split(File::SEPARATOR)
      genre = path_parts[0] if path_parts.length > 1

      next unless genre && expected_genres.include?(genre)

      genres_found.add(genre)

      file_size = File.size(file_path)
      
      # Try to get duration (simplified - you might want to use a gem like taglib-ruby or ruby-audio)
      duration = nil
      begin
        # For MP3 files, we can estimate based on file size (rough approximation)
        # For WAV files, we can calculate from file size and sample rate
        # This is a simplified approach - in production, use a proper audio library
        if file_path.downcase.end_with?('.wav')
          # WAV: file_size = header_size + (sample_rate * channels * bits_per_sample / 8 * duration)
          # Simplified: assume 44.1kHz, 16-bit, stereo
          header_size = 44
          sample_rate = 44100
          channels = 2
          bits_per_sample = 16
          audio_data_size = file_size - header_size
          duration = audio_data_size.to_f / (sample_rate * channels * (bits_per_sample / 8))
        elsif file_path.downcase.end_with?('.mp3')
          # MP3: rough estimate based on bitrate (assume 128kbps)
          # This is very approximate
          bitrate = 128000 # 128 kbps
          duration = (file_size * 8).to_f / bitrate
        end
      rescue => e
        puts "Warning: Could not calculate duration for #{file_path}: #{e.message}"
      end

      song = Song.find_or_initialize_by(full_path: File.join(base_path, relative_path))
      song.assign_attributes(
        dataset: dataset,
        genre: genre,
        filename: filename,
        relative_path: relative_path,
        full_path: File.join(base_path, relative_path),
        file_size: file_size,
        duration: duration
      )
      
      if song.save
        songs_count += 1
      else
        puts "Error saving song #{file_path}: #{song.errors.full_messages.join(', ')}"
      end
    end

    # Update dataset metadata
    dataset.update(
      total_songs: songs_count,
      genres: genres_found.to_a.sort
    )

    puts "  - Found #{songs_count} songs in #{genres_found.size} genres"
    puts "  - Genres: #{genres_found.to_a.sort.join(', ')}"
  end
end

