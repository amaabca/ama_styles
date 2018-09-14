# frozen_string_literal: true

module AMA
  module Styles
    module Internal
      module Chat
        def chat_message(msg, opts = {})
          color = opts.fetch(:color, 'good')
          attachment = {
            fallback: msg,
            color: color,
            text: msg
          }
          client.post(attachments: [attachment])
        end

        def start_deploy_message(opts = {})
          user = opts.fetch(:user)
          branch = opts.fetch(:branch)
          environment = opts.fetch(:environment)
          "#{user} is deploying ama_styles/#{branch}" \
          " to #{environment} (#{Rails.env})"
        end

        def end_deploy_message(opts = {})
          user = opts.fetch(:user)
          branch = opts.fetch(:branch)
          environment = opts.fetch(:environment)
          "#{user} finished deploying ama_styles/#{branch}" \
          " to #{environment} (#{Rails.env})"
        end

        private

        def client
          @client = Slack::Notifier.new(webhook_url) do
            defaults(
              channel: ENV.fetch('SLACK_CHANNEL'),
              username: ENV.fetch('SLACK_USERNAME', 'Deployments')
            )
          end
        end

        def webhook_url
          ENV.fetch('SLACK_WEBHOOK_URL')
        end
      end
    end
  end
end
