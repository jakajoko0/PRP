namespace :assets do 
	desc 'Precompile assets locally and then rsync them to server'
	task :precompile do 
		run_locally do 
			with rails_env: fetch(:stage) do 
				execute :bundle, 'exec rake assets:precompile'
			end
		end

		on roles(:web), in: :parallel do |server|
			run_locally do 
				execute :rsync,
				  "--progress -a --delete ./public/packs/ #{"staging18"}:#{release_path}/public/packs/"
				execute :rsync,
				  "--progress -a --delete ./public/assets/ #{"staging18"}:#{release_path}/public/assets/"
			end
		end

		run_locally do 
			execute :sudo, :chown, "-R dev:dev public/assets" 
			execute :sudo, :chown, "-R dev:dev public/packs" 
			execute :rm, '-rf public/assets'
			execute :rm, '-rf public/packs'
		end
	end
end