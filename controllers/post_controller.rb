require 'json'
require './models/user'
require './models/post'
require './utils/response'

class PostController

    def self.create(params)
        post = Post.new({
            "user_id" => params["user_id"].to_i,
            "body" => params["body"]
        })

        user = User.by_id(post.user_id)
        return DefaultResponse.not_found unless user
        
        return DefaultResponse.internal_server_error unless post.save

        response = DefaultResponse.created
        response[:body] = {
            :post => post
        }
        return response
    end

    def self.show_by_id(params)
        post = Post.by_id(params["id"].to_i)
        return DefaultResponse.not_found unless post

        response = {
            :status => 200,
            :body => {
                :post => post
            }
        }
        return response
    end

    def self.find(params)
        posts = Post.all
        response = {
            :status => 200,
            :body => {
                :posts => posts
            }
        }
    end
end