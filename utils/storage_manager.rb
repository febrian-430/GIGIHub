require 'fileutils'
require 'securerandom'

class StorageManager
    @@dest = "public/"
    
    # @files = [{
    #     @filename
    #     @type
    #     @bytes
    # }]
    def self.store(files)
        generated_files = []
        
        files.each do |file|
            #get extension
            p file[:filename]
            ext = file["filename"].split('.')[-1]
            filename = SecureRandom.uuid
            filename += "."+ext

            File.open("./public/#{filename}", 'wb') do |f|
                f.write(file["file"].read)
            end

            generated_files << {
                "filename" => filename,
                "mimetype" => file["mimetype"]
            }
        end
        generated_files
    end
end