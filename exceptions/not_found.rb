class NotFoundError < StandardError
    def initialize(msg="Not found in database")
        super
    end
end