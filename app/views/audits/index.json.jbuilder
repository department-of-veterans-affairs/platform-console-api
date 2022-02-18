# frozen_string_literal: true

json.array! @audits, partial: 'audits/audit', as: :audit
