module Github
  module Inspect

  # Text representation of the objects, masking tokens
  #
  # @return [String]
  def inspect
    inspected = super

    # Only show last 4 of token
    inspected.gsub! @access_token, "#{'*'*36}#{@access_token[36..-1]}" if @access_token
    inspected
  end
  end
end
