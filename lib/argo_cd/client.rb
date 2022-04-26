# frozen_string_literal: true

require_relative 'response'

module ArgoCd
  # Client class for interacting with ArgoAPI
  class Client
    attr_accessor :app_id, :deployment_name, :current_user

    def initialize(app_id, deployment_name, current_user_id)
      @app_id = app_id
      @deployment_name = deployment_name
      @current_user = User.find(current_user_id)
    end

    def app_info
      uri = URI("#{base_path}/api/v1/applications?name=#{deployment_name}")
      get_app_info(uri, :get)
    end

    def current_revision(revision)
      uri = URI("#{base_path}/api/v1/applications/#{deployment_name}/revisions/#{revision}/metadata")
      get_app_info(uri, :get)
    end

    def destroy_token
      token_id = current_user.token_id
      uri = URI("#{base_path}/api/v1/account/#{ENV['ARGO_USER']}/token/#{token_id}")
      get_app_info(uri, :delete)
    end

    def get_app_info(uri, verb)
      https = Net::HTTP.new(uri.host, uri.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development? || Rails.env.test?
      https.use_ssl = true if Rails.env.production?
      response = https.method(verb).call(uri, request_headers)

      Response.new(response: response)
    end

    def request_headers
      {
        'Authorization' => "Bearer #{jwt}",
        'Content-Type' => 'application/json'
      }
    end

    private

    def base_path
      ENV['ARGO_API_BASE_PATH']
    end

    def jwt
      current_user.keycloak_token
    end
  end
end
