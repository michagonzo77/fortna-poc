terraform {
  required_providers {
    kubiya = {
      source = "kubiya-terraform/kubiya"
    }
  }
}

provider "kubiya" {
  // Your Kubiya API Key will be taken from the
  // environment variable KUBIYA_API_KEY
  // To set the key, please use export KUBIYA_API_KEY="YOUR_API_KEY"
}

resource "kubiya_agent" "agent" {
  // Mandatory Fields
  name         = "OpenShift CLI" // String
  runner       = "aks-runner"     // String
  description  = <<EOT
OpenShift CLI is an agent that can manage OpenShift CLI commands.
EOT
  instructions = <<EOT
You are an intelligent agent designed to help with all OpenShift tasks.
EOT
  // Optional fields, String
  model = "azure/gpt-4o" // If not provided, Defaults to "azure/gpt-4"
  // If not provided, Defaults to "ghcr.io/kubiyabot/kubiya-agent:stable"
  image = "kubiya/base-agent:tools-v4"

  // Optional Fields:
  // Arrays
  secrets      = ["OPENSHIFT_TOKEN", "OPENSHIFT_API_URL"]
  integrations = ["slack"]
  users        = []
  groups       = ["Admin", "Users"]
  links = []
  environment_variables = {
    DEBUG                        = "1"
    LOG_LEVEL                    = "INFO"
    KUBIYA_TOOL_CONFIG_URLS      = "hhttps://github.com/michagonzo77/fortna-poc"
    TOOLS_MANAGER_URL            = "http://localhost:3001"
    TOOLS_SERVER_URL             = "http://localhost:3001"
    TOOL_MANAGER_LOG_FILE        = "/tmp/tool-manager.log"
    TOOL_SERVER_URL              = "http://localhost:3001"
  }
}

output "agent" {
  value = kubiya_agent.agent
}
