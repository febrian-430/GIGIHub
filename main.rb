require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'

require 'json'
require 'dotenv'
require './controllers/user_controller'
require './controllers/post_controller'
require './controllers/tag_controller'
require './controllers/comment_controller'

require 'securerandom'
require './utils/storage_manager'

require './models/user'

Dotenv.load

before '/*' do
    content_type :json
    puts params[:splat].inspect
    routes_with_file_uploads = ["posts", "comments", "upload"]

    if !routes_with_file_uploads.include?(params[:splat][0]) && request.body.size > 0
        request.body.rewind
        @body = JSON.parse(request.body.read)
    end
end


get '/static/:filename' do
    content_type 'image/webp'
    send_file File.expand_path(params["filename"], settings.public_folder)
end


get '/users/:username' do
    response = UserController.show_by_username(@body)
    return [response[:status], json(response[:body])]
end

post '/users' do
    response = UserController.create(@body)
    return [response[:status], json(response[:body])]
end

put '/users/:id' do
    response = UserController.update(@body)
    return [response[:status], json(response[:body])]
end 

post '/posts' do
    response = PostController.create(params)
    return [response[:status], json(response[:body])]
end

get '/posts/:id' do
    response = PostController.show_by_id(params)
    return [response[:status], json(response[:body])]
end

get '/posts' do
    response = PostController.find(params)
    return [response[:status], json(response[:body])]
end

get '/tags/trending' do
    response = TagController.trending_tags
    return [response[:status], json(response[:body])]
end

post '/comments' do
    response = CommentController.create(params)
    return [response[:status], json(response[:body])]
end




  