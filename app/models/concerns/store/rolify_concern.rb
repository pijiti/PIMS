module Store::RolifyConcern
  extend ActiveSupport::Concern

  included do
    resourcify
  end

end