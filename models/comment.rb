require './utils/JSONable'
require './exceptions/not_found'
require './models/post'
require './models/user'


class Comment < JSONable
    attr_accessor :id, :body, :post_id, :user_id, :created_at, :updated_at, :post, :user
    def initialize(params)
        @id = params["id"]
        @body = params["body"]
        @post_id = params["post_id"]
        @user_id = params["user_id"]
        @created_at = params["created_at"]
        @updated_at = params["updated_at"]

        @post = nil
        @user = nil
        puts self.inspect
    end

    def save?
        return false if @body.nil? || @body.empty?
        return false if @user_id.nil?
        return false if @post_id.nil?
        
        @user = User.by_id(@user_id)
        raise NotFoundError if @user.nil?

        @post = Post.by_id(@post_id)
        raise NotFoundError if @post.nil?

        return true
    end

end