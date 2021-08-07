class User
    attr_accessor :id, :username, :email, :bio_description
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

    def update?
        return false if @id.nil? || @id <= 0
        return false if @username.nil? || @username.empty?
        return false if @email.nil? || @email.empty?
        true
    end

    def update
        return false unless self.update?

        MySQLDB.client.query("UPDATE users username = '#@username', email = '#@email', bio_desc = '#@bio_desccription' WHERE id = #@id")
        true
    end
end