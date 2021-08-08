require 'mysql2'

class MySQLDB
    @@singleton_client = nil

    def self.client
        if !@@singleton_client
            @@singleton_client = new_client
        end
        @@singleton_client
    end

    def self.new_client
        client=Mysql2::Client.new(
            :host => ENV["HOST"],
            :username => ENV["DB_USER_NAME"],
            :password => ENV["DB_USER_PASSWORD"],
            :database => ENV["DB_NAME"]
        )
        client
    end

    def self.transaction(&block)
        transaction_client = new_client
        raise false unless block_given?
        begin
            transaction_client.query("START TRANSACTION")
            yield(transaction_client)
            transaction_client.query("COMMIT")
            return true
        rescue => exception
            transaction_client.query("ROLLBACK")
            return false
        end
    end
end