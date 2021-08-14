require './utils/JSONable'
require './utils/storage_manager'

class Attachment < JSONable
    def initialize(params)
        @id = params["id"]
        @filename = params["filename"]
        @mimetype = params["mimetype"]
    end

    def self.attach_to(obj, files = [])
        raise NotImplementedError
    end
    
    def self.store_files(files = [])
        StorageManager.store(files)
    end
end