# frozen_string_literal: true

class ConnectedApp < ApplicationRecord
  belongs_to :app
  belongs_to :user
  has_paper_trail
end
