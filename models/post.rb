require './db/mysql'
require './models/tag'
require './utils/JSONable'
require './utils/parser'
require './exceptions/not_found'

class Post < JSONable
    attr_accessor :body, :created_at, :updated_at, :user_id, :user, :tags
    attr_reader :id
    
    def initialize(params)
        @id = params["id"]
        @body = params["body"]
        @created_at = params["created_at"]
        @updated_at = params["updated_at"]
        @user = nil
        @user_id = params["user_id"].to_i
        @tags = []
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
        client = MySQLDB.client
        raw_tags = Parser.hashtags(@body)
        
        begin
            client.query("INSERT INTO posts(user_id, body) values(#@user_id, '#@body')")
            #race condition might happen here
            @id = client.last_id

            Tag.insert_post_tags(@id, raw_tags) unless raw_tags.empty?
        rescue NotFoundError => ex
            raise ex
        end
        
        true
    end

    def self.all(filter)
        posts = []
        result = MySQLDB.client.query(
            "SELECT p.*
            FROM posts p
            JOIN (post_tags pt CROSS JOIN tags t)
            ON (p.id = pt.post_id AND t.id = pt.tag_id)
            WHERE (#{filter["tag"].nil? || filter["tag"].empty? } = true OR t.name = '#{filter["tag"]}')
            ORDER BY p.created_at DESC")
        raw = result.each
        raw.each do |row|
            post = Post.new({
                "id" => row["id"],
                "body" => row["body"],
                "created_at" => row["created_at"],
                "updated_at" => row["updated_at"],
                "user_id" => row["user_id"]
            })
            post.user = User.by_id(post.user_id)
            posts.push post
        end
        return posts
    end

    def self.by_id_exists(id)
        return true if find(id)
        return false
    end

    def self.by_id(id)
        row = find(id)
        post = nil
        return post unless row

        post = Post.new(row)
        post.user = User.by_id(post.user_id)
        post.tags = Tag.by_post(post.id)

        return post
    end

    #private
    def self.find(id)
        client = MySQLDB.client
        result = client.query("SELECT * FROM posts WHERE id = #{id}")
        row = result.each[0]
    end

    private_class_method :find
end