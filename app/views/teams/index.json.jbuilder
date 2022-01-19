# frozen_string_literal: true

json.array! @teams, partial: 'teams/team', as: :team
