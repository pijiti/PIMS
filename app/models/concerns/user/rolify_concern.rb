module User::RolifyConcern
  extend ActiveSupport::Concern

  included do
    rolify
  end

end