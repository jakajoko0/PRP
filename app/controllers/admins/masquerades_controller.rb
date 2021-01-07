class Admins::MasqueradesController < Devise::MasqueradesController
	def show
		super
		logger.debug "Masqueraded Resource Class : #{masqueraded_resource_class}"
		logger.debug "Masqueraded Resource Name : #{masqueraded_resource_name}"
		logger.debug "Masquerading Resource Class : #{masquerading_resource_class}"
		logger.debug "Masquerading Resource Name : #{masquerading_resource_name}"
		
	end

	protected
	def masquerade_authorize!
		authorize!(:masquerade, User)
	end

end