# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'
module Github
  # Module containing a graphQL client and queries for github
  module GraphQL
    # Download GraphQL schema
    unless File.exist?(Rails.root.join('lib/github/graph_ql/schema.json'))
      adapter = ::GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
        def headers(_context)
          { 'Authorization' => "Bearer #{ENV['GITHUB_ACCESS_TOKEN']}" }
        end
      end
      ::GraphQL::Client.dump_schema(adapter, 'lib/github/graph_ql/schema.json')
    end

    # Configure GraphQL endpoint using the basic HTTP network adapter.
    HTTP = ::GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
      def headers(context)
        token = context[:access_token]
        raise 'Missing GitHub access token' if token.blank?

        {
          'Authorization' => "Bearer #{token}"
        }
      end
    end

    Schema = ::GraphQL::Client.load_schema('lib/github/graph_ql/schema.json')
    Client = ::GraphQL::Client.new(schema: Schema, execute: HTTP)

    ## Queries
    # Query to get various stats for the app's github repository
    GithubInfoQuery = Github::GraphQL::Client.parse <<~'GRAPHQL'
      query($owner: String!, $name: String!) {
        repo: repository(owner: $owner, name: $name) {
          open_issues: issues(states: OPEN) {
          totalCount
          }
          branches: refs(first: 0, refPrefix: "refs/heads/") {
            totalCount
          }
          pull_requests: pullRequests(states:OPEN) {
            totalCount
          }
          releases: releases {
            totalCount
          }
          latest_release: latestRelease{
            name
          }
        }
      }
    GRAPHQL
  end
end
