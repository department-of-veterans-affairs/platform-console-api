# frozen_string_literal: true

json.array! @deployments, partial: 'deployments/deployment', as: :deployment
