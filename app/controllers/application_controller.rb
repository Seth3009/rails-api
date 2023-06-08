class ApplicationController < ActionController::API
  #protect_from_forgery with: :null_session #disable Cross site request forgery
  include Response
  include Authenticate
  include SerializableResource
end
