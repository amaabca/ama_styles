namespace :assets do
  desc "Deploy to a particular environment"
  task :deploy do
    AMA::Styles::Deployment.new.run
  end
end
