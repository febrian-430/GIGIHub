require './db/mysql'
require './utils/JSONable'

class Post < JSONable

    def initialize(params)
        @id = params["id"]
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
    end
end