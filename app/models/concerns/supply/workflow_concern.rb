module Supply::WorkflowConcern
  extend ActiveSupport::Concern

 included do
    include Workflow

    workflow do

      state :created do
        event :submit, transitions_to: :submitted
      end

      state :submitted do
        event :approve, transitions_to: :approved
        event :disapprove, transitions_to: :disapproved
      end

      state :approved do

      end

      state :disapproved do

      end

    end
  end

end