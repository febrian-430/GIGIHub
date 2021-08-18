require './models/model'
require './exceptions/not_found'
require './models/post'
require './models/user'
require './models/tag'
require './models/comment_attachment'
require './utils/parser'


class Comment < Model
    attr_reader :id, :body, :post_id, :user_id, :created_at, :updated_at, :post, :user, :raw_attachments
    attr_accessor :attachment
    def initialize(params)
        @showable_variables = ["id", "body", "created_at", "updated_at", "post", "user", "attachment"]
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

        post = Post.by_id_exists?(@post_id)
        raise NotFoundError unless post

        return true
    end

    def save
        #let controller handle notfounderror
        return false unless self.save?
        
        tags = Parser.hashtags(@body)
        puts self.class
        client = MySQLDB.client
        #let controller handle mysql2::error
        client.query("INSERT INTO comments(post_id, user_id, body) values(#{@post_id}, #{@user_id}, '#{@body}')")

        @id = client.last_id

        Tag.insert_comment_tags(client.last_id, tags) unless tags.empty?
        CommentAttachment.attach_to(self, [@raw_attachment]) unless @raw_attachment.nil?

        true
    end

    def self.by_post(post_id)
        post = Post.by_id_exists?(post_id)
        raise NotFoundError unless post
        
        client = MySQLDB.client
        result = client.query("SELECT * FROM comments WHERE post_id = #{post_id}")
        
        comments = bind(Comment, result)
        
        comments.each_index do |index|
            comments[index].load
        end
        
        return comments  
    end

    def load
        @user = User.by_id(@user_id)
        @attachment = CommentAttachment.by_comment(@id)
    end
end