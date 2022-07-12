# frozen_string_literal: true

module Github
  # Collection methods
  module Collection
    def self.included(klass)
      def klass.transform_collection_response(response, pages, repo, app_id)
        {
          pages: pages,
          objects: response.map do |object|
            OpenStruct.new({
                             id: object.id,
                             repo: repo,
                             app_id: app_id,
                             github: object
                           })
          end
        }
      end
    end

    def transform_collection_response(response, pages, repo, app_id)
      {
        pages: pages,
        objects: response.map do |object|
          OpenStruct.new({
                           id: object.id,
                           repo: repo,
                           app_id: app_id,
                           github: object
                         })
        end
      }
    end
  end
end
