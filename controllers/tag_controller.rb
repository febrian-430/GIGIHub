require 'json'
require './models/user'

class TagController
    def self.trending_tags
        tags = Tag.top(5)

        response = {
            :status => 200,
            :body => {
                :tags => tags
            }
        }
    end
end