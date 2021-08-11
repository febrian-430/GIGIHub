require './utils/JSONable'
require './exceptions/not_found'
require './models/post'
require './models/user'


class Comment < JSONable
    attr_accessor :id, :body, :post_id, :user_id, :created_at, :updated_at, :post, :user
    def initialize(params)
        @id = params["id"]
        @body = params["id"]
        @post_id = params["post_id"]
        @user_id = params["user_id"]
        @created_at = params["created_at"]
        @updated_at = params["updated_at"]

        @post = nil
        @user = nil
    end

    def save?
        return false if @body.nil? || @body.empty?
        true
    end

end