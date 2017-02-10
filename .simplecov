SimpleCov.start 'rails' do
  SimpleCov.minimum_coverage 100.00
  # We load the version in the gemspec, which
  # confuses SimpleCov.
  add_filter 'lib/ama/styles/version'
end
