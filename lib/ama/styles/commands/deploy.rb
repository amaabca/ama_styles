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
          verify_git!
          environment_context do
            hipchat_deploy_start
            dry_run || Rake::Task['assets:deploy'].invoke
            hipchat_deploy_end
          end
        end

        private

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
          if local_branch && remote_branch
            verify_changed_files
            verify_commit_digests
          else
            raise GitError, "invalid branch: #{branch}"
          end
        end

        def verify_commit_digests
          if remote_branch.gcommit.sha != local_branch.gcommit.sha
            raise GitError, 'local git repo is stale - please pull'
          end
        end

        def verify_changed_files
          if git.status.changed.count != 0
            raise GitError, 'there are uncommitted changes'
          end
        end

        def local_branch
          git.branches[branch]
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
