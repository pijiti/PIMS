class ApplicationController < ActionController::Base
   include CurrentstoreConcern
   include Pundit

  protect_from_forgery with: :exception

    alias_method :me, :current_user



end

