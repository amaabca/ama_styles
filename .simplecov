# frozen_string_literal: true

SimpleCov.start 'rails' do
  SimpleCov.minimum_coverage 100.00
  add_filter 'lib/ama/styles/version'
  add_filter 'lib/ama/styles/internal/chat'
  add_filter 'lib/ama/styles/internal/commands/deploy'
  add_filter 'lib/ama/styles/internal/environment'
end
