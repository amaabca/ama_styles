# frozen_string_literal: true

module AMA
  module Styles
    module Internal
      class CLI
        ENVIRONMENTS = %w[development staging production].freeze
        COMMANDS = %w[deploy build].freeze
        InvalidArgument = Class.new(StandardError)

        attr_accessor :argv, :dry_run, :branch

        def initialize(opts = {})
          self.argv = opts.fetch(:argv)
          self.branch = opts.fetch(:branch)
          self.dry_run = opts.fetch(:dry_run, false)
        end

        def parse_and_execute
          parse_environment.execute
        end

        private

        def parse_command
          case command
          when 'deploy'
            Commands::Deploy.new(
              branch: branch,
              environment: environment,
              dry_run: dry_run
            )
          when 'build'
            Commands::Build.new
          else
            invalid_argument!(command_message)
          end
        end

        def parse_environment
          if ENVIRONMENTS.include?(environment)
            parse_command
          else
            invalid_argument!(environment_message)
          end
        end

        def command
          argv[1]
        end

        def environment
          argv[0]
        end

        def command_message
          if command
            "invalid command: #{command}"
          else
            'command argument must be specified (i.e. deploy)'
          end
        end

        def environment_message
          if environment
            "invalid environment: #{environment}"
          else
            'environment argument must be specified (i.e. staging)'
          end
        end

        def invalid_argument!(msg)
          raise InvalidArgument, msg
        end
      end
    end
  end
end
