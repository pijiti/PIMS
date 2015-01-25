module Role::RolifyConcern
  extend ActiveSupport::Concern

  included do
    scopify
  end

end