require 'mysql2'

class MySQLDB
    @@singleton_client = nil
    def self.client
        if !@@singleton_client
            @@singleton_client = Mysql2::Client.new(
                :host => ENV["HOST"],
                :username => ENV["DB_USER_NAME"],
                :password => ENV["DB_USER_PASSWORD"],
                :database => ENV["DB_NAME"]
            )
        end
        @@singleton_client
    end
end