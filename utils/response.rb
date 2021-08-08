class DefaultResponse 
    def self.not_found
        return {:status => 404}
    end

    def self.internal_server_error
        return {:status => 500}
    end

    def self.created
        return {:status => 201}
    end
end