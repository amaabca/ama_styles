# frozen_string_literal: true

unless github.pr_author.include?('dependabot')
  # Link to any relevant VSTS tickets(old or new domain) or OpsGenie alerts
  urls = %w[
    https://amaabca.visualstudio.com
    https://dev.azure.com
    https://app.opsgenie.com
    AB#
  ]
  unless urls.any? { |url| github.pr_body.include?(url) }
    fail 'Please provide a VSTS, ADO link or OPSGENIE link in the Pull Request description 💩'
  end
end
