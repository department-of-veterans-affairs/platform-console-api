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

      if current_user.argo_token_invalid?
        token_response = generate_token
        return token_response unless token_response.successful?
      end

      get_app_info(uri)
    end

    def get_app_info(uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
      response = https.get(uri, request_headers)

      if Rails.env.production?
        response = Net::HTTP.get_response(URI.parse(response['location']))
      end

      Response.new(response: response)
    end

    def request_headers
      {
        'Authorization' => "Bearer #{jwt}",
        'Content-Type' => 'application/json'
      }
    end

    def current_deploy
      # TODO: - dig in after first iteration
    end

    private

    def base_path
      return 'https://localhost:8080' unless Rails.env.production?

      ENV['ARGO_API_BASE_PATH']
    end

    def jwt
      current_user.argo_token
    end

    def generate_token
      uri = URI("#{base_path}/api/v1/session")
      https = Net::HTTP.new(uri.host, uri.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

      request = build_request(uri)

      r = https.request(request)

      if Rails.env.production?
        r = Net::HTTP.get_response(URI.parse(r['location']))
      end

      response = Response.new(response: r)

      save_token(response) if response.successful?

      response
    end

    def build_request(uri)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = { "username": ENV['ARGO_USER'], "password": ENV['ARGO_PWD'] }.to_json
      request['Content-Type'] = 'application/json'
      request
    end

    def save_token(response)
      token = response.token
      current_user.argo_token = token
      current_user.save!
    end
  end
end
