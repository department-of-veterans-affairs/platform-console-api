# frozen_string_literal: true

module ArgoCd
  # Response class for ArgoAPI
  class Response
    attr_reader :body, :status

    def initialize(opts)
      @body = JSON.parse(opts[:response].body) || []
      @status = opts[:response].code.to_i
    end

    def successful?
      status == 200
    end

    def error_message
      body['error']
    end

    def app_info
      @app_info ||= body['items'][0]['status']
    end

    def app_health
      app_info['health']['status']
    end

    def app_health_message
      app_info['health']['message']
    end

    def current_git_info
      @current_git_info ||= app_info['sync']
    end

    def current_git_status
      current_git_info['status']
    end

    def current_git_revision
      current_git_info['revision']
    end

    def previous_git_info
      @previous_git_info ||= app_info['history'][0]
    end

    def previous_git_revision
      previous_git_info['revision']
    end

    def previous_git_deployed_at
      previous_git_info['deployedAt']
    end

    def sync_status
      @sync_status ||= body['status']['sync']
    end

    def author
      @author ||= body['author']
    end

    def date
      @date ||= body['date']
    end

    def message
      @message ||= body['message']
    end

    def token
      @token ||= body['token']
    end
  end
end
