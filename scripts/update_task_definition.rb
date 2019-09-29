# frozen_string_literal: true

require "aws-sdk-ecs"

# (1) Define the ECS client, deep_copy method and the base task definition

client = Aws::ECS::Client.new

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

base_td = {
            container_definitions: [
              {
                log_configuration: {
                  log_driver: "awslogs",
                  options: {
                    "awslogs-stream-prefix" => "ecs",
                    "awslogs-region" => "ap-southeast-1"
                  }
                },
                port_mappings: [
                  {
                    host_port: 8080,
                    protocol: "tcp",
                    container_port: 8080
                  }
                ],
                name: "web"
              }
            ],
            placement_constraints: [],
            memory: "1024",
            cpu: "512",
            volumes: []
          }

# (2) All env variables prepended "ECS_" will be included in the task definition

env_vars = []

relevant_envs = ENV.select { |k, _| k[0..3] == "ECS_" }

relevant_envs.each do |key, value|
  # skip this variable from being included
  next if key == "ECS_CONTAINER_METADATA_URI"

  proper_key = key.gsub("ECS_", "").to_sym
  env_vars << {
    name: proper_key,
    value: value
  }
end

# (3) Define how the web task definition and the sidekiq task definition differs

log = {
  web: ENV["CLOUDWATCH_WEB_LOG_GROUP"],
  sidekiq: ENV["CLOUDWATCH_SIDEKIQ_LOG_GROUP"],
}

base_td[:container_definitions][0][:image] = "#{ENV['REPO_URL']}:#{ENV['LATEST_VERSION']}"
base_td[:container_definitions][0][:environment] = env_vars

web_td = deep_copy(base_td)
web_td[:container_definitions][0][:command] = ["puma", "-C", "config/docker_puma.rb", "-p", "8080"]
web_td[:container_definitions][0][:log_configuration][:options]["awslogs-group"] = log[:web]
web_td[:container_definitions][0][:name] = "web"
web_td[:requires_compatibilities] = ["EC2"]
web_td[:family] = ENV["TASK_DEFINITION_WEB"]
web_td[:network_mode] = nil

sidekiq_td = deep_copy(base_td)
sidekiq_td[:container_definitions][0][:command] = ["sidekiq", "-C", "config/sidekiq.yml"]
sidekiq_td[:container_definitions][0][:log_configuration][:options]["awslogs-group"] = log[:sidekiq]
sidekiq_td[:container_definitions][0][:name] = "web"
sidekiq_td[:requires_compatibilities] = ["EC2"]
sidekiq_td[:family] = ENV["TASK_DEFINITION_SIDEKIQ"]
sidekiq_td[:network_mode] = nil

# (4) Create a new revision of the web and sidekiq task definitions

client.register_task_definition(web_td)
client.register_task_definition(sidekiq_td)
