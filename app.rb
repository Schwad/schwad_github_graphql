# Inspiration credit to: https://medium.com/devnetwork/interacting-with-github-graphql-api-in-ruby-6a09249dd44f

require 'pry'
require 'graphql/client'
require 'graphql/client/http'
require 'virtus'
require_relative 'reload'
require_relative 'error_handling'


module Github
  GITHUB_ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN']
  URL = 'https://api.github.com/graphql'
  HttpAdapter = GraphQL::Client::HTTP.new(URL) do
    def headers(context)
      {
        "Authorization" => "Bearer #{GITHUB_ACCESS_TOKEN}",
        "User-Agent" => 'Ruby'
      }
    end
  end
  Schema = GraphQL::Client.load_schema(HttpAdapter)
  Client = GraphQL::Client.new(schema: Schema, execute: HttpAdapter)
end

require_relative 'queries'


module Github
  class User
    UserProfileQuery = Github::Client.parse <<-'GRAPHQL'
      query($username: String!) {
        user(login: $username) {
          id
          login
          name
          avatarUrl
          bio
          bioHTML
          location
        }
      }
    GRAPHQL
    def self.find(username)
      response = Github::Client.query(UserProfileQuery, variables: { username: username })
      if response.errors.any?
        raise QueryExecutionError.new(response.errors[:data].join(", "))
      else
        response.data.user
      end
    end
  end
end
