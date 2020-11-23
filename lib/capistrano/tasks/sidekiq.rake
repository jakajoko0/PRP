namespace :sidekiq do 
	desc "Quiet Sidekiq (stop fetching new tasks)"
	task :quiet do 
		roles(:app) do 
			execute :sudo, :systemctl, :kill, "-s", "TSTP", 'sidekiq'
		end
	end

	desc "Restart Sidekiq service"
	task :restart do 
		roles(:app) do 
		  execute :sudo, :systemctl, :restart, :sidekiq
		end
	end

end