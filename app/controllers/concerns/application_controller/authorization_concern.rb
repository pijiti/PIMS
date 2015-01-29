module ApplicationController::AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    include Pundit
  end

end