# frozen_string_literal: true

# For application-wide helpers
module ApplicationHelper
  # The active_link_to gem may be a better alternative if we outgrow this
  def active_link_to(name = nil, options = {}, html_options = {}, &block)
    if current_page?(options) || options == "/#{request.env['PATH_INFO'].split('/')[1].split('?')[0]}"
      html_options[:class] += ' border-indigo-500 text-gray-900'
    else
      html_options[:class] += ' border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'
    end

    link_to name, options, html_options, &block
  end
end
