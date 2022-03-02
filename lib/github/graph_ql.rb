# frozen_string_literal: true

module Github
  # Module containing a graphQL client and queries for github
  module GraphQL
    # Setup GraphQL
    unless File.exist?(Rails.root.join('tmp/github_graphql_schema.json'))
      # Download GraphQL schema
      adapter = ::GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
        def headers(_context)
          { 'Authorization' => "Bearer #{ENV['GITHUB_ACCESS_TOKEN']}" }
        end
      end
      ::GraphQL::Client.dump_schema(adapter, 'tmp/github_graphql_schema.json')
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

    # Fetch latest schema on init, this will make a network request
    # Schema = GraphQL::Client.load_schema(HTTP)

    # However, it's smart to dump this to a JSON file and load from disk
    #
    # Run it from a script or rake task
    # ::GraphQL::Client.dump_schema(HTTP, 'tmp/github_graphql_schema.json')
    Schema = ::GraphQL::Client.load_schema('tmp/github_graphql_schema.json')

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
