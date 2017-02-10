# frozen_string_literal: true

module Helpers
  module Requests
    def stub_api_deployment(opts = {})
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body)
      with_auth(api_post).to_return(
        body: body,
        status: status
      )
    end

    private

    def api_post
      stub_request(
        :post,
        Rails.configuration.api_deployment_url
      )
    end

    def with_auth(request)
      request.with(
        basic_auth: [
          Rails.configuration.api_deployment_user,
          Rails.configuration.api_deployment_password
        ]
      )
    end
  end
end
