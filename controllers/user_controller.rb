require 'json'
require './models/user'

class UserController
    def self.create(params)
        user = User.new(
            username: params["username"],
            email: params["email"],
            bio_description: params["bio_description"]
        )

        return {
            :status => 400,
            :body => {
                :message => "Request body does not meet its criteria",
                :ack => false
            }
        } unless user.save

        return {
            :status => 201,
            :body => {
                :message => "user successfully created",
                :ack => true,
                :created_user => user
            }
        }
    end

    def self.update(params)
        user = User.by_id(params["id"].to_i)
        
        return {
            :status => 404
        } unless user

        user.username = params["username"]
        user.email = params["email"]
        user.bio_description = params["bio_description"]

        return {
            :status => 400
        } unless user.update

        return {
            :status => 200,
            :body => {
                :user => user
            }
        }
    end

    def self.show_by_username(params)
        user = User.by_username(params["username"])

        return {
            :status => 404
        } unless user

        return {
            :status => 200,
            :body => {
                :user => user
            }
        }
    end
end