module ApiKeyAuthenticatable

  extend ActiveSupport::Concern

  attr_reader :current_api_key
  attr_reader :current_bearer


  # Use this for API key authentication
  def authenticate_with_api_key
    header = request.headers["Authorization"]
    pattern = /^Bearer /
    if header && header.match(pattern)
      token = header.gsub(pattern,'') if header && header.match(pattern)
      @current_api_key = ApiKey.authenticate_by_token! token
      @current_bearer = @current_api_key&.bearer
    else
      render json: {message: "Please provide proper credentials" }, status: :unauthorized
    end
  end
end