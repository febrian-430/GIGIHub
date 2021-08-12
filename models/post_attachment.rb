require './utils/JSONable'

class PostAttachment < JSONable
    def initialize
        @id = params["id"]
        @filename = params["filename"]
    end
end