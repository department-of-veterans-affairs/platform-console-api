# frozen_string_literal: true

# Presenter for user (e.g. current_user)
class UserPresenter < ApplicationPresenter
  def initials
    name.split.map(&:first).join
  end
end
