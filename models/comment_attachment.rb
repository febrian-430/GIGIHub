require './models/comment'
require './models/attachment'

class CommentAttachment < Attachment
    def initialize(params)
        def initialize(params)
            super(params)
            @comment_id = params["comment_id"].to_i
        end
    end

    def self.attach_to(obj, files = [])
        raise(TypeError, "expected Comment instance") unless obj.instance_of? Comment
        return 0 if files.empty?
        
        client = MySQLDB.client
        
        stored_files = store_files(files)

        query = build_insert_query(obj, stored_files)
        client.query(query)

        return client.affected_rows
    end

    def self.by_comment(comment_id)
        client = MySQLDB.client
        query_result = client.query("SELECT catt.* FROM comment_attachments catt JOIN comments c ON catt.comment_id = c.id 
            WHERE c.id = #{comment_id}")

        attachments = bind(CommentAttachment, query_result)
        return attachments[0]
    end

    def self.build_insert_query(comment, files)
        query = "INSERT INTO comment_attachments(comment_id, filename, mimetype) VALUES"
        insert_elements = files.map { |file| "(#{comment.id}, '#{file["filename"]}','#{file["mimetype"]}')" }
        query += insert_elements.join(',')
        return query
    end

    private_class_method :build_insert_query
end