# config valid for current version and patch releases of Capistrano

lock "~> 3.14.1"

set :application, "prp"
set :repo_url, "git@github.com:PBSITProjects/PRP.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/prp"

set :sidekiq_service_name, "sidekiq"


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle" , "public/system", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

#after 'deploy:published', 'nginx:reload'
#after 'deploy:published', 'nginx:restart'


namespace :sidekiq do 
	desc "Quiet Sidekiq (stop fetching new tasks)"
	task :quiet do 
		on roles(:app) do 
			execute :sudo, :systemctl, :kill, "-s", "TSTP", fetch(:sidekiq_service_name)
		end
	end

	desc "Restart Sidekiq service" do 
		task :restart do 
			on roles(:app) do 
				execute :sudo, :systemctl, :restart, fetch(:sidekiq_service_name)
			end
		end
	end
end

after "deploy:starting", "sidekiq:quiet"
after "deploy:updated", "assets:precompile"
after "deploy:published", "sidekiq:restart"