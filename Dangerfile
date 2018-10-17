# frozen_string_literal: true

# Link to any relevant VSTS tickets or OpsGenie alerts
unless github.pr_body.include?('https://amaabca.visualstudio.com') || github.pr_body.include?('https://app.opsgenie.com')
  raise 'Please provide a VSTS or OpsGenie link in the Pull Request description 💩'
end

# Add reviewer emojis
if %w[🎨 🐘 :art: :elephant:].none? { |s| github.pr_body.include?(s) }
  raise 'Please add reviewer emojis in the Pull Request description 💩'
end

# Do not let 'binding.pry' get into master by accident
raise 'A binding.pry was committed 💩' if system 'grep -r binding.pry . --exclude=Dangerfile'

# Do not let 'debugger' get into master by accident
raise 'A debugger was committed 💩' if system 'grep -r debugger . --exclude=Dangerfile'
