require './models/user'

class UserController
    def self.create(params)
        user = User.new(
            username: params[:username],
            email: params[:email],
            bio_description: params[:bio_description]
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
end