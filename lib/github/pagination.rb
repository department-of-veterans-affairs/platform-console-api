# frozen_string_literal: true

module Github
  # Pagination methods
  module Pagination
    def self.included(klass)
      def klass.page_numbers(octokit_client)
        rels = octokit_client.last_response.process_rels
        pages = {}
        rels.each do |k, v|
          pages[k] = Addressable::URI.parse(v.href).query_values['page'] if v.present?
        end
        pages
      end
    end

    def page_numbers(octokit_client)
      self.class.page_number(octokit_client)
    end
  end
end
