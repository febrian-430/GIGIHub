require './db/mysql'
require './utils/model'
require './exceptions/user_errors'

class User < Model
    attr_accessor :username, :email, :bio_description
    attr_reader :id

    def initialize(params)
        @showable_variables = ["id", "username", "email", "bio_description", "join_date"]
        @id = params["id"].to_i
        @username = params["username"]
        @email = params["email"]
        @bio_description = params["bio_description"]
        @join_date = params["join_date"]
    end

    def save? 
        return false if @username.nil? || @username.empty?
        return false if @email.nil? || @email.empty?
        
        return true if self.duplicate? 
    end

    def save
        return false unless self.save?

        client = MySQLDB.client
        client.query("INSERT INTO users (username, email, bio_description) values('#@username', '#@email', '#@bio_description')")
        @id = client.last_id
        
        true
    end

    def duplicate?
        raise UserErrors::DuplicateEmail if User.by_email(@email)
        raise UserErrors::DuplicateUsername if User.by_username(@username)
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

    def self.by_email(email)
        result = MySQLDB.client.query("SELECT * FROM users WHERE email = '#{email}'")
        users = bind(result)
        return users[0]
    end

    def self.by_username(username)
        result = MySQLDB.client.query("SELECT * FROM users WHERE username = '#{username}'")
        users = bind(result)
        return users[0]
    end

    def self.by_id(id)
        result = MySQLDB.client.query("SELECT * FROM users WHERE id = #{id}")
        users = bind(result)
        return users[0]
    end

    def self.bind(raw)
        result = []
        raw.each do |data|
            result << User.new(data)
        end
        return result
    end
end