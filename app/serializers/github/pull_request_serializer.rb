# frozen_string_literal: true

module Github
  class PullRequestSerializer < ::BaseSerializer
    attributes :url, :id, :node_id, :html_url, :diff_url, :patch_url, :issue_url, :number, :state, :locked, :title,
               :user, :body, :created_at, :updated_at, :closed_at, :merged_at, :merge_commit_sha, :assignee, :assignees,
               :requested_reviewers, :requested_teams, :labels, :milestone, :draft, :commits_url, :review_comments_url,
               :review_comment_url, :comments_url, :statuses_url, :head, :base, :_links, :author_association,
               :auto_merge, :active_lock_reason

    belongs_to :repository
  end
end
