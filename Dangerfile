# frozen_string_literal: true

unless github.pr_author.include?('dependabot')
  # Link to any relevant VSTS tickets(old or new domain) or OpsGenie alerts
  urls = %w[
    https://amaabca.visualstudio.com
    https://dev.azure.com
    https://app.opsgenie.com
  ]
  unless urls.any? { |url| github.pr_body.include?(url) }
    fail 'Please provide a VSTS, ADO link or OPSGENIE link in the Pull Request description 💩'
  end

  # Do not let 'binding.pry' get into master by accident
  fail 'A binding.pry was committed 💩' if system 'grep -r binding.pry . --exclude=Dangerfile --exclude-dir=vendor'

  # Do not let 'debugger' get into master by accident
  fail 'A debugger was committed 💩' if system 'grep -r debugger . --exclude=Dangerfile --exclude-dir=vendor'
end
