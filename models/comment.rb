require './utils/JSONable'
require './exceptions/not_found'
require './models/post'
require './models/user'
require './models/tag'
require './models/comment_attachment'
require './utils/parser'


class Comment < JSONable
    attr_reader :id, :body, :post_id, :user_id, :created_at, :updated_at, :post, :user
    def initialize(params)
        @showable_variables = ["id", "body", "created_at", "updated_at", "post", "user"]
        @id = params["id"]
        @body = params["body"]
        @post_id = params["post_id"]
        @user_id = params["user_id"]
        @created_at = params["created_at"]
        @updated_at = params["updated_at"]
        @raw_attachment = params["attachment"]
         
        @post = nil
        @user = nil
        @attachment = nil
    end

    def save?
        return false if @body.nil? || @body.empty?
        return false if @user_id.nil? || @user_id == 0
        return false if @post_id.nil? || @user_id == 0

        @user = User.by_id(@user_id)
        raise NotFoundError if @user.nil?

        @post = Post.by_id(@post_id)
        raise NotFoundError if @post.nil?

        return true
    end

    def save
        #let controller handle notfounderror
        return false unless self.save?
        tags = Parser.hashtags(@body)
        client = MySQLDB.client

        #let controller handle mysql2::error
        client.query("INSERT INTO comments(post_id, user_id, body) values(#{@user_id}, #{@post_id}, '#{@body}')")
        @id = client.last_id
        Tag.insert_comment_tags(client.last_id, tags) unless tags.empty?

        CommentAttachment.attach_to(self, [@raw_attachment]) unless @raw_attachment.nil?
        true
    end
end