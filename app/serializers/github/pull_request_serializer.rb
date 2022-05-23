# frozen_string_literal: true

module Github
  class PullRequestSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :repository
  end
end
