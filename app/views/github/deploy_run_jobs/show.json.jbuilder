# frozen_string_literal: true

# json.deploy_run_job @github_deploy_run_job.github.to_h

json.set! :deploy_run_job do
  @github_deploy_run_job.github.to_h.each do |k, v|
    json.set!(k, v)
    json.logs @github_deploy_run_job.logs
  end
end
