# frozen_string_literal: true

module AMA
  module Styles
    module Internal
      module Chat
        def chat_message(msg, opts = {})
          color = opts.fetch(:color, 'good')
          attachment = {
            color: color,
            title: msg,
            fields: [
              { title: 'Environment', value: opts.fetch(:environment), short: true },
              { title: 'Branch', value: opts.fetch(:branch), short: true },
              { title: 'Deployer', value: opts.fetch(:user), short: true }
            ],
            fallback: msg
          }

          if color.eql?('good')
            attachment[:fields] << {
              title: 'Time',
              value: elapsed_time,
              short: true
            }
          end

          client.post(attachments: [attachment])
        end

        def start_deploy_message(opts = {})
          ":eyes: #{opts.fetch(:user)} is deploying Ama_Styles/#{opts.fetch(:branch)} to #{opts.fetch(:environment)}"
        end

        def end_deploy_message(opts = {})
          ":bangbang: #{opts.fetch(:user)} has deployed Ama_Styles/#{opts.fetch(:branch)} to #{opts.fetch(:environment)}"
        end

        private

        def elapsed_time
          `ps -p #{Process.pid} -o etime=`.strip
        end

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
