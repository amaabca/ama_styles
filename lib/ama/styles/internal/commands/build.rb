# frozen_string_literal: true

module AMA
  module Styles
    module Internal
      module Commands
        class Build
          def execute
            run
          end

          private

          def run
            environment_context do
              Rake::Task['assets:precompile'].invoke
            end
          end

          def environment_context
            initialize_application
            yield
          end

          def initialize_application
            AMA::Styles::Application.load_tasks
            AMA::Styles::Application.initialize!
          end
        end
      end
    end
  end
end
