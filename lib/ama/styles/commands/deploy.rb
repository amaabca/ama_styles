# frozen_string_literal: true
module AMA
  module Styles
    module Commands
      class Deploy
        GitError = Class.new(StandardError)
        include Hipchat
        attr_accessor :environment, :branch, :dry_run

        def initialize(opts = {})
          self.dry_run = opts.fetch(:dry_run, false)
          self.environment = opts.fetch(:environment)
          self.branch = opts.fetch(:branch) { 'master' }
        end

        def execute
          dry_run || run
        end

        private

        def run
          environment_context do
            verify_git!
            hipchat_deploy_start
            Rake::Task['assets:deploy'].invoke
            hipchat_deploy_end
          end
        end

        def normalized_environment
          if environment == 'staging'
            'production'
          else
            environment
          end
        end

        def environment_context
          Dotenv.overload(".env.#{environment}")
          AMA::Styles::Application.load_tasks
          AMA::Styles::Application.initialize!
          yield
        end

        def hipchat_deploy_start
          hipchat_message(
            start_deploy_message(
              user: git_user,
              branch: branch,
              environment: environment
            ),
            color: :yellow
          )
        end

        def hipchat_deploy_end
          hipchat_message(
            end_deploy_message(
              user: git_user,
              branch: branch,
              environment: environment
            )
          )
        end

        def verify_git!
          raise GitError, "invalid branch: #{branch}" unless branches
          fetch_branches
          checkout_branch
          verify_changed_files
          verify_commit_digests
        end

        def checkout_branch
          git.branch(branch).checkout
        end

        def branches
          local_branch && remote_branch
        end

        def verify_commit_digests
          message = 'local git repo is stale - please pull'
          raise GitError, message unless digest_match
        end

        def digest_match
          remote_branch.gcommit.sha == local_branch.gcommit.sha
        end

        def verify_changed_files
          message = 'there are uncommitted changes'
          raise GitError, message unless git.status.changed.count.zero?
        end

        def local_branch
          git.branches[branch]
        end

        def fetch_branches
          git.remote('origin').fetch
        end

        def remote_branch
          git.branches["origin/#{branch}"]
        end

        def git_user
          git.config['user.name']
        end

        def git
          @git ||= Git.open('.')
        end
      end
    end
  end
end
