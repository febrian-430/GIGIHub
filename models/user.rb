require './db/mysql'
require './utils/JSONable'

class User < JSONable
    attr_accessor :username, :email, :bio_description
    attr_reader :id

    def initialize(id: nil, username: nil, email: nil, bio_description: nil, join_date: nil)
        @showable_variables = ["id", "username", "email", "bio_description", "join_date"]
        @id = id
        @username = username
        @email = email
        @bio_description = bio_description
        @join_date = join_date
    end

    def save? 
        return false if @username.nil? || @username.empty?
        return false if @email.nil? || @email.empty?
        true 
    end

    def save
        return false unless self.save?
        client = MySQLDB.client
        client.query("INSERT INTO users (username, email, bio_description) values('#@username', '#@email', '#@bio_description')")
        @id = client.last_id
        true
    end

    def update?
        return false if @id.nil? || @id <= 0
        return false if @username.nil? || @username.empty?
        return false if @email.nil? || @email.empty?
        true
    end

    def update
        return false unless self.update?

        MySQLDB.client.query("UPDATE users SET username = '#@username', email = '#@email', bio_description = '#@bio_description' WHERE id = #@id")
        true
    end

    def self.by_username(username)
        result = MySQLDB.client.query("SELECT * FROM users WHERE username = '#{username}'")
        row = result.each[0]
        return nil unless row

        user = User.new(
            id: row["id"].to_i, 
            username: row["username"], 
            email: row["email"],
            bio_description: row["bio_description"],
            join_date: row["join_date"]
        )
        return user
    end

    def self.by_id(id)
        result = MySQLDB.client.query("SELECT * FROM users WHERE id = #{id}")
        row = result.each[0]
        return nil unless row

        user = User.new(
            id: row["id"].to_i, 
            username: row["username"], 
            email: row["email"],
            bio_description: row["bio_description"],
            join_date: row["join_date"]
        )
        return user
    end
end