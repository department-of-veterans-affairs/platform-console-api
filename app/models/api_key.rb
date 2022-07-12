class ApiKey
  belongs_to :bearer, polymorphic: true
  encrypts :token
end
