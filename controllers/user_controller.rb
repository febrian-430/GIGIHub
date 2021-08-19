require 'json'
require './models/user'
require './exceptions/user_errors'


class UserController
    def self.create(params)
        user = User.new({
            "username" => params["username"],
            "email" => params["email"],
            "bio_description" => params["bio_description"]
        })
        begin
            return {
                :status => 400,
                :body => {
                    :message => "Request body does not meet its criteria",
                }
            } unless user.save

        rescue UserErrors::DuplicateEmail => ex
            return {
                :status => 400,
                :body => {
                    :message => "#{ex.message}"
                }
            }

        rescue UserErrors::DuplicateUsername => ex
            return {
                :status => 400,
                :body => {
                    :message => "#{ex.message}"
                }
            }
        end

        return {
            :status => 201,
            :body => {
                :message => "user successfully created",
                :created_user => user
            }
        }
    end

    def self.show_by_username(params)
        puts params.inspect
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