require './models/user'

class UserController
    def self.create(params)
        user = User.new(
            username: params[:username],
            email: params[:email],
            bio_description: params[:bio_description]
        )
        return {
            :status => "400",
            :message => "Request body does not meet its criteria",
            :ack => false
        }
    end
end