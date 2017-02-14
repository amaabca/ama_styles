SimpleCov.start 'rails' do
  SimpleCov.minimum_coverage 100.00
  add_filter 'lib/ama/styles/version'
  add_filter 'lib/ama/styles/internal/hipchat'
  add_filter 'lib/ama/styles/internal/commands/*'
end
