# frozen_string_literal: true

# For application-wide helpers
module ApplicationHelper
  # The active_link_to gem may be a better alternative if we outgrow this
  def active_link_to(name = nil, options = {}, html_options = {}, &block)
    if current_page?(options) || options == "/#{request.env['PATH_INFO'].split('/')[1].split('?')[0]}"
      html_options[:class] += " #{html_options.delete(:active_class)}"
    else
      html_options[:class] += " #{html_options.delete(:inactive_class)}"
    end

    link_to name, options, html_options, &block
  end

  # rubocop:disable Metrics/MethodLength
  def nav_links
    {
      main: [
        { name: I18n.t('navbar.teams'), path: teams_path },
        {
          name: I18n.t('navbar.docs'),
          path: 'https://depo-platform-documentation.scrollhelp.site/developer-docs/index.html',
          target: '_blank'
        },
        {
          name: I18n.t('navbar.support'),
          path: 'https://dsva.slack.com/archives/CBU0KDSB1',
          target: '_blank'
        }
      ],
      drop: [
        { name: I18n.t('navbar.drop.sign_out'), path: '/logout' }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength

  def present(model)
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new model, self
    block_given? ? yield(presenter) : presenter
  end
end
