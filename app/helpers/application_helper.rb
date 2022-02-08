# frozen_string_literal: true

# For application-wide helpers
module ApplicationHelper
  include Pagy::Frontend

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
        { name: I18n.t('navbar.datadog'), path: datadog_link, target: '_blank' },
        { name: I18n.t('navbar.loki'), path: loki_link, target: '_blank' },
        { name: I18n.t('navbar.sentry'), path: sentry_link, target: '_blank' },
        {
          name: I18n.t('navbar.support'),
          path: 'https://dsva.slack.com/archives/CBU0KDSB1',
          target: '_blank'
        }
      ],
      drop: nav_links_drop
    }
  end
  # rubocop:enable Metrics/MethodLength

  def nav_links_drop
    nav_links_drop_admin + [
      { name: I18n.t('navbar.drop.sign_out'), path: '/logout' }
    ]
  end

  def nav_links_drop_admin
    if current_user&.has_role? :admin
      [
        { name: I18n.t('navbar.drop.flipper'), path: '/flipper' },
        { name: I18n.t('navbar.drop.sidekiq'), path: '/sidekiq' }
      ]
    else
      []
    end
  end

  def present(model)
    klass = "#{model.class}Presenter".constantize
    presenter = klass.new model, self
    block_given? ? yield(presenter) : presenter
  end

  def datadog_link
    'https://app.datadoghq.com/apm/home'
  end

  def loki_link
    'http://grafana.vfs.va.gov/'
  end

  def sentry_link
    'http://sentry.vfs.va.gov/'
  end
end
