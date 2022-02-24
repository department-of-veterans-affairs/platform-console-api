# frozen_string_literal: true

json.set! :workflow_run_job do
  @github_workflow_run_job.github.to_h.each do |k, v|
    json.set!(k, v)
    json.logs @github_workflow_run_job.logs
  end
end
