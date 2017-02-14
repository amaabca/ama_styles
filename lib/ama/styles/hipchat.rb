module AMA
  module Styles
    module Hipchat
      def hipchat_message(msg, opts = {})
        color = opts.fetch(:color, :green)
        client[room].send('Deploy', msg, color: color)
      end

      def start_deploy_message(opts = {})
        user = opts.fetch(:user)
        branch = opts.fetch(:branch)
        environment = opts.fetch(:environment)
        "#{user} is deploying ama_styles/#{branch}" +
        " to #{environment} (#{Rails.env})"
      end

      def end_deploy_message(opts = {})
        user = opts.fetch(:user)
        branch = opts.fetch(:branch)
        environment = opts.fetch(:environment)
        "#{user} finished deploying ama_styles/#{branch}" +
        " to #{environment} (#{Rails.env})"
      end

      private

      def client
        ::HipChat::Client.new(api_token)
      end

      def api_token
        ENV.fetch('HIPCHAT_TOKEN')
      end

      def room
        ENV.fetch('HIPCHAT_ROOM')
      end
    end
  end
end
