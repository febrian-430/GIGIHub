require './models/attachment'
require './exceptions/type_mismatch'
require './db/mysql'

class PostAttachment < Attachment

    def initialize(params)
        super(params)
        @showable_variables = ["id", "filename", "mimetype"]
        @post_id = params["post_id"]
    end

    def self.attach_to(obj, files = [])
        raise(TypeError, "expected Post instance") unless obj.instance_of? Post
        return 0 if files.empty?
        client = MySQLDB.client
        filenames = store_files(files)
        query = "INSERT INTO post_attachments(post_id, filename, mimetype) VALUES"
        
        insert_elements = files.map { |file| "(#{obj.id}, '#{file["filename"]}','#{file["mimetype"]}')" }
        query += insert_elements.join(',')
        client.query(query)
        return client.affected_rows
    end

    def self.by_post(post_id)
        post = Post.by_id_exists(post_id)
        raise NotFoundError unless post

        client = MySQLDB.client
        raw = client.query("SELECT patt.* FROM post_attachments patt JOIN posts p ON patt.post_id = p.id 
            WHERE p.id = #{post_id}")
        attachments = bind(raw)
        return attachments
    end

    #private
    def self.bind(data)
        attachments = []
        data.each do |row| 
            attachment = PostAttachment.new(row)
            attachments << attachment
        end
        attachments
    end
    private_class_method :bind
end