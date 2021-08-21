require './models/attachment'
require './db/mysql'

class PostAttachment < Attachment

    def initialize(params)
        super(params)
        @post_id = params["post_id"]
    end

    def self.attach_to(obj, files = [])
        raise(TypeError, "expected Post instance") unless obj.instance_of? Post
        return 0 if files.empty?

        stored_files = store_files(files)

        query = build_insert_query(obj, stored_files)

        client = MySQLDB.client
        client.query(query)

        return client.affected_rows
    end

    def self.by_post(post_id)
        post = Post.by_id_exists?(post_id)
        raise NotFoundError unless post

        client = MySQLDB.client
        query_result = client.query("SELECT patt.* FROM post_attachments patt JOIN posts p ON patt.post_id = p.id 
            WHERE p.id = #{post_id}")

        attachments = bind(PostAttachment, query_result)
        return attachments
    end

    def self.build_insert_query(obj, files)
        query = "INSERT INTO post_attachments(post_id, filename, mimetype) VALUES"
        insert_elements = files.map { |file| "(#{obj.id}, '#{file["filename"]}','#{file["mimetype"]}')" }
        query += insert_elements.join(',')
        
        return query
    end
end