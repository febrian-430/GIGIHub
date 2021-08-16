require './models/comment'
require './models/attachment'

class CommentAttachment < Attachment
    def initialize(params)
        def initialize(params)
            super(params)
            @showable_variables = ["id", "filename", "mimetype"]
            @post_id = params["comment_id"]
        end
    end

    def self.attach_to(obj, files = [])
        raise(TypeError, "expected Comment instance") unless obj.instance_of? Comment
        return 0 if files.empty?
        
        client = MySQLDB.client
        
        filenames = store_files(files)

        query = "INSERT INTO comment_attachments(comment_id, filename, mimetype) VALUES"
        insert_elements = files.map { |file| "(#{obj.id}, '#{file["filename"]}','#{file["mimetype"]}')" }
        query += insert_elements.join(',')
        client.query(query)

        return client.affected_rows
    end
end