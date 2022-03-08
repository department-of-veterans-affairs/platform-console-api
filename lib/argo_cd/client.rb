# frozen_string_literal: true

require_relative 'response'

module ArgoCd
  # Client class for interacting with ArgoAPI
  class Client
    attr_accessor :app_id, :deployment_name, :current_user_id

    def initialize(app_id, deployment_name, current_user_id)
      @app_id = app_id
      @deployment_name = deployment_name
      @current_user_id = current_user_id
    end

    def app_info
      uri = URI("#{base_path}/api/v1/applications?name=#{deployment_name}")

      if connected_app.blank? || token_expired?(connected_app)
        token_response = generate_token
        return token_response unless token_response.successful?
      end

      get_app_info(uri)
    end

    def get_app_info(uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
      response = https.get(uri.path, request_headers)

      Response.new(response: response)
    end

    def request_headers
      {
        'Authorization' => "Bearer #{jwt_token}",
        'Content-Type' => 'application/json'
      }
    end

    def current_deploy
      # TODO: - dig in after first iteration
    end

    private

    def base_path
      if Rails.env.development? || Rails.env.test?
        'https://localhost:8080'
      else
        'https://argocd.vfs.va.gov/api/v1'
      end
    end

    def connected_app
      @connected_app ||= ConnectedApp.find_by(user_id: current_user_id, app_id: app_id)
    end

    def jwt_token
      connected_app.token
    end

    def token_expired?(connected_app)
      connected_app.updated_at + 24.hours < DateTime.now # token has expired
    end

    def generate_token
      uri = URI("#{base_path}/api/v1/session")
      https = Net::HTTP.new(uri.host, uri.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

      request = build_request(uri)

      r = https.request(request)
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
      connected_app = ConnectedApp.find_or_create_by(user_id: current_user_id, app_id: app_id)
      connected_app.token = token
      connected_app.save!
    end
  end
end
