class Users::MasqueradesController < Devise::MasqueradesController
	def show
		super
		# logger.debug "Resource: #{resource}"
		# the_key = params[Devise.masquerade_param]
		
		# logger.debug "THE KEY: #{the_key}"
		# logger.debug "THE OTHER KEY: #{the_key}"
		# logger.debug "RAILS CACHE THING: #{::Rails.cache.read(cache_masquerade_key_by(the_key))}"

		# logger.debug "Masqueraded Resource Class : #{masqueraded_resource_class}"
		# logger.debug "Masqueraded Resource Name : #{masqueraded_resource_name}"
		# logger.debug "Masquerading Resource Class : #{masquerading_resource_class}"
		# logger.debug "Masquerading Resource Name : #{masquerading_resource_name}"
		
	end

	protected
	def masquerade_authorize!
		authorize!(:masquerade, User)
	end

end