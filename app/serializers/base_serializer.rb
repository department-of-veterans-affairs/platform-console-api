# frozen_string_literal: true

class BaseSerializer
  include JSONAPI::Serializer
  extend SerializerHelper
end
