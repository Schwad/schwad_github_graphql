##
#
# Welcome to the Github known API queries area
#

# Get a User Profile

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
