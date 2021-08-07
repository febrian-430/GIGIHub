class User
    def initialize(id: nil, username: nil, email: nil, bio_description: nil)
        @id = id
        @username = username
        @email = email
        @bio_description = bio_description
    end

    def save? 
        return false if @username.nil? || @username.empty?
        return false if @email.nil? || @email.empty?
        true 
    end

    def save
        return false unless self.save?
        client = MySQLDB.client
        client.query("INSERT INTO users (username, email, bio_desc) values('#@username', '#@email', '#@bio_desccription'")
        @id = client.last_id
    end
end