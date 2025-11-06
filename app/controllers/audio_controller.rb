class AudioController < ApplicationController
  def serve
    dataset_name = params[:dataset].upcase
    genre = params[:genre]
    filename = params[:filename]

    # Validate dataset
    dataset = Dataset.find_by(name: dataset_name)
    unless dataset
      head :not_found
      return
    end

    # Construct file path
    file_path = File.join(dataset.base_path, genre, filename)
    
    # Security: Prevent directory traversal
    normalized_path = File.expand_path(file_path)
    normalized_base = File.expand_path(dataset.base_path)
    
    unless normalized_path.start_with?(normalized_base)
      head :forbidden
      return
    end

    # Check if file exists
    unless File.exist?(normalized_path) && File.file?(normalized_path)
      head :not_found
      return
    end

    # Determine content type
    content_type = case File.extname(filename).downcase
                   when '.mp3'
                     'audio/mpeg'
                   when '.wav'
                     'audio/wav'
                   else
                     'application/octet-stream'
                   end

    # Serve file
    send_file normalized_path,
              type: content_type,
              disposition: 'inline',
              x_sendfile: true
  end
end

