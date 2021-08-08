require './models/post'
require './exceptions/not_found'
require './utils/JSONable'


class Tag < JSONable
    def initialize(params)
        @id = params["id"]
        @name = params["name"]
        @created_at = params["created_at"]
    end

    def self.insert_post_tags(post_id, raw_tags = [])
        post = Post.by_id(post_id.to_i)
        raise NotFoundError unless post

        link_tags_to_post!(post.id, raw_tags) unless raw_tags.empty?
        true
    end

    def self.by_post(post_id)
        post = Post.by_id_exists(post_id.to_i)
        raise NotFoundError unless post

        client = MySQLDB.client
        raw = client.query("SELECT t.* FROM tags t JOIN post_tags pt ON t.id = pt.tag_id 
            WHERE post_id = #{post_id}")
        tags = bind(raw)
        return tags
    end

    def self.bind(raw)
        tags = []
        raw.each do |row| 
            tag = Tag.new(row)
            tags << tag
        end
        tags
    end

    #private 
    def self.link_tags_to_post!(post_id, raw_tags=[])
        return 0 if raw_tags.empty?

        bulk_insert!(raw_tags)
        client = MySQLDB.client
        query = "INSERT IGNORE INTO post_tags(post_id, tag_id)
        SELECT #{post_id}, id
        FROM tags
        WHERE name IN (#{raw_tags.map { |tag| "'#{tag}'" }.join(',')})"
        puts query

        client.query(query)
        return client.affected_rows
    end

    #private
    def self.bulk_insert!(raw_tags = [])
        return 0 if raw_tags.empty?

        client = MySQLDB.client
        statement = "INSERT IGNORE INTO tags(name) VALUES"
        inserted_ids = []
        query_elements = raw_tags.map {
            |tag|
            "('%s')" % tag
        }
        statement += query_elements.join(',')
        
        client.query(statement)
        return client.affected_rows
    end

    private_class_method :bulk_insert!, :link_tags_to_post!, :bind
end