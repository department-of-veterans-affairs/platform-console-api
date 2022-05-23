# frozen_string_literal: true

module Github
  class RepositorySerializer < ::BaseSerializer
    attributes :repo, :github

    set_id :repo
    has_many :workflows, id_method_name: :workflow_ids
  end
end
