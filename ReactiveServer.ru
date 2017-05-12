require 'sinatra'
require "json"

henrik = {"userId" => 1, "displayName" => "Henrik", "avatarUrl" => "http://qapital-ios-testtask.herokuapp.com/avatars/henrik.jpg", "enabled" => true}
mikael = {"userId" => 2, "displayName" => "Mikael", "avatarUrl" => "http://qapital-ios-testtask.herokuapp.com/avatars/mikael.jpg", "enabled" => true}
johan = {"userId" => 3, "displayName" => "Johan", "avatarUrl" => "http://qapital-ios-testtask.herokuapp.com/avatars/johan.jpg", "enabled" => true}
users = {1 => henrik, 2 => mikael, 3 => johan}

before do
  if request.body.size > 0
    request.body.rewind
    @post_payload = JSON.parse request.body.read
    # @request_payload = JSON.parse request.body.read
  end
end

get '/users' do
  return users.values.to_json
end

post '/user' do
  payload = @post_payload
  userId = payload["userId"]
  users[userId] = payload
  ''
end
