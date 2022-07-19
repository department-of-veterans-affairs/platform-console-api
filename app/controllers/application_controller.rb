# frozen_string_literal: true

# Base controller that all controllers inherits= from.
class ApplicationController < ActionController::Base
  include Authenticatable
  include ApiKeyAuthenticable
  include Pagy::Backend
  before_action :set_paper_trail_whodunnit

  def collection_options(pagination)
    options = {}
    options[:is_collection] = true

    options[:links] =
      case pagination
      when Pagy
        {
          next: pagination.next.present? ? "#{request.base_url}#{request.path}#{"?page=#{pagination.next}"}" : nil,
          prev: pagination.prev.present? ? "#{request.base_url}#{request.path}#{"?page=#{pagination.prev}"}" : nil,
          last: pagination.last.present? ? "#{request.base_url}#{request.path}#{"?page=#{pagination.last}"}" : nil
        }

      when Hash
        {
          next: pagination[:next].present? ? "#{request.base_url}#{request.path}#{"?page=#{pagination[:next]}"}" : nil,
          prev: pagination[:prev].present? ? "#{request.base_url}#{request.path}#{"?page=#{pagination[:prev]}"}" : nil,
          last: pagination[:last].present? ? "#{request.base_url}#{request.path}#{"?page=#{pagination[:last]}"}" : nil
        }
      end
    options
  end
end
