agent_name         = "Deploy New Environments"
kubiya_runner      = "aks-runner"
agent_description  = "Deploy New Environments is an agent that can deploy new environments (prod, dev, etc.) on OpenShift for team/project."
agent_instructions = <<EOT
You are an intelligent agent designed to help with all OpenShift tasks.
EOT
llm_model          = "azure/gpt-4o"
agent_image        = "kubiya/base-agent:tools-v5"

secrets            = ["OPENSHIFT_USERNAME", "OPENSHIFT_PASSWORD", "OPENSHIFT_API_URL"]
integrations       = ["slack"]
users              = []
groups             = ["Admin"]
agent_tool_sources = ["https://github.com/michagonzo77/fortna-poc"]
links              = []
environment_variables = {
    LOG_LEVEL = "INFO"
    KUBIYA_TOOL_TIMEOUT = "5m"
    KUBIYA_DEBUG = "1"   
}