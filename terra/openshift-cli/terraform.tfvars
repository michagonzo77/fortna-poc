agent_name         = "OpenShift CLI"
kubiya_runner      = "aks-runner"
agent_description  = "OpenShift CLI is an agent that can manage OpenShift CLI commands."
agent_instructions = <<EOT
You are an intelligent agent designed to help with all OpenShift tasks.
EOT
llm_model          = "azure/gpt-4o"
agent_image        = "kubiya/base-agent:tools-v4"

secrets            = ["OPENSHIFT_USERNAME", "OPENSHIFT_PASSWORD", "OPENSHIFT_API_URL"]
integrations       = ["slack"]
users              = []
groups             = ["Admin"]
agent_tool_sources = ["https://github.com/michagonzo77/fortna-poc"]
links              = []
environment_variables = {}

// Decide whether to enable debug mode
// Debug mode will enable additional logging, and will allow visibility on Slack (if configured) as part of the conversation
// Very useful for debugging and troubleshooting
// DO NOT USE IN PRODUCTION
debug = false
