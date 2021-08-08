class Tag
    def initialize(params)
        @id = params["id"]
        @name = params["name"]
        @created_at = params["created_at"]
    end

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

    def self.link_tags_to_post!(post_id, raw_tags=[])
        bulk_insert!(raw_tags)
        client = MySQLDB.client
        client.query(
            "INSERT INTO tags(post_id, tag_id)
            SELECT #{post_id}, id
            FROM tags
            WHERE name IN (#{raw_tags.join(',')})"
        )
        return client.affected_rows
    end
end