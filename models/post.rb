require './db/mysql'
require './models/tag'
require './models/model'
require './utils/parser'
require './exceptions/not_found'
require './models/post_attachment'
require './models/comment'


class Post < Model
    attr_accessor :body, :created_at, :updated_at, :user_id, :user, :tags, :attachments
    attr_reader :id, :comments
    attr_writer :raw_attachments
    
    def initialize(params)
        @showable_variables = ["id", "body", "created_at", "updated_at", "user", "tags", "attachments", "comments"]
        @id = params["id"]
        @body = params["body"]
        @created_at = params["created_at"]
        @updated_at = params["updated_at"]
        
        @user = nil
        @user_id = params["user_id"].to_i

        @tags = []
        @comments = []
        
        @raw_attachments = params["attachments"].to_a
        @attachments = []
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
        
        raw_tags = Parser.hashtags(@body)
        
        client = MySQLDB.client
        begin
            client.query("INSERT INTO posts(user_id, body) values(#@user_id, '#@body')")
            @id = client.last_id

            Tag.insert_post_tags(@id, raw_tags) unless raw_tags.empty?
            PostAttachment.attach_to(self, @raw_attachments) unless @raw_attachments.empty?
        rescue NotFoundError => ex
            raise ex
        end

        true
    end

    def self.all(filter = {})
        posts = []

        result = MySQLDB.client.query(
            "SELECT p.*
            FROM posts p
            JOIN (post_tags pt CROSS JOIN tags t)
            ON (p.id = pt.post_id AND t.id = pt.tag_id)
            WHERE (#{filter["tag"].nil? || filter["tag"].empty? } = true OR t.name = LOWER('#{filter["tag"]}'))
            GROUP BY p.id
            ORDER BY p.created_at DESC"
        )

        raw = result.each
        posts = bind(Post ,raw)

        return posts
    end

    def self.by_id_exists?(id)
        return true if find(id)
        return false
    end

    def load
        @user = User.by_id(@user_id)
        @tags = Tag.by_post(@id)
        @attachments = PostAttachment.by_post(@id)
        @comments = Comment.by_post(@id)
    end
    
    def self.by_id(id)
        row = find(id)

        post = nil
        return post unless row
        post = Post.new(row)

        post.load
        return post
    end

    #private
    def self.find(id)
        client = MySQLDB.client

        result = client.query("SELECT * FROM posts WHERE id = #{id}")
        
        row = result.each[0]
        row
    end

    private_class_method :find
end