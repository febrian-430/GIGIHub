require './db/mysql'
require './utils/JSONable'

class Post < JSONable
    attr_accessor :body, :created_at, :updated_at, :user_id
    attr_reader :user, :id
    def initialize(params)
        @id = nil
        @body = params["body"]
        @created_at = params["created_at"]
        @updated_at = params["updated_at"]
        @user = nil
        @user_id = params["user_id"]
        # if params[:user_id] 
        #     @user = User.by_id(params[:user_id].to_i)
        # end
    end

    def save?
        return false if @body.nil? || @body.empty?
        return false if @user_id.nil?
        @user = User.by_id(@user_id)
        return false if @user.nil?
        true
    end

    def save
        return false unless self.save?

        MySQLDB.client.query("INSERT INTO posts(user_id, body) values(#@user_id, '#@body')")
        #race condition might happen here
        @id = MySQLDB.client.last_id
        true
    end
end