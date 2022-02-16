# frozen_string_literal: true

module Github
  # Base Class for Github classes
  class Base
    def self.page_links(octokit_client)
      rels = octokit_client.last_response.process_rels
      pages = {}
      rels.each do |k, v|
        pages[k] = Addressable::URI.parse(v.href).query_values['page'] if v.present?
      end
      pages
    end

    def page_links(octokit_client)
      self.class.page_links(octokit_client)
    end
  end
end
