namespace :sidekiq do 
	desc "Quiet Sidekiq (stop fetching new tasks)"
	task :quiet do 
		roles(:app) do 
			execute :sudo, :systemctl, :kill, "-s", "TSTP", fetch(:sidekiq_service_name)
		end
	end

	desc "Restart Sidekiq service" do 
		task :restart do 
			roles(:app) do 
				execute :sudo, :systemctl, :restart, fetch(:sidekiq_service_name)
			end
		end
	end
end