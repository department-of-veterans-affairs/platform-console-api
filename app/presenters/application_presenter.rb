# frozen_string_literal: true

# Base presenter for other presenters to inherit from
class ApplicationPresenter < SimpleDelegator
  def initialize(model, view)
    @view = view
    super model
  end

  def h
    @view
  end
end
