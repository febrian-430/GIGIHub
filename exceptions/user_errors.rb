module UserErrors
    class DuplicateEmail < StandardError
        def initialize(msg="Email already exists in database")
            super
        end
    end

    class DuplicateUsername < StandardError
        def initialize(msg="Username already exists in database")
            super
        end
    end
end