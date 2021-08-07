class User
    def initialize(id: nil, username: nil, email: nil, bio_description: nil, joined_at: nil)
        @id = id
        @username = username
        @email = email
        @bio_description = bio_description
        @joined_at = joined_at
    end

    def save? 
        return false if @username.nil? || @username.empty?
        return false if @email.nil? || @email.empty?
        true 
    end
end