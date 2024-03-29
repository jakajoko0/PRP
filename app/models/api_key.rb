class ApiKey < ApplicationRecord
  HMAC_SECRET_KEY = Rails.application.credentials.dig(:api_key_hmac_secret_key)

	attr_accessor :token

	belongs_to :bearer, polymorphic: true

	before_create :generate_token_hmac

	def self.authenticate_by_token!(token)
    digest = OpenSSL::HMAC.hexdigest 'SHA256', HMAC_SECRET_KEY, token
    find_by! token_digest: digest
  end


  # Add virtual token attribute to serializable attributes, and exclude
  # the token's HMAC digest
  def serializable_hash(options = nil)
    h = super options.merge(except: 'token_digest')
    h.merge! 'token' => token if token.present?
    h
  end

  private

  def generate_token_hmac
    raise ActiveRecord::RecordInvalid, 'token is required' unless token.present?

    digest = OpenSSL::HMAC.hexdigest 'SHA256', HMAC_SECRET_KEY, token

    self.token_digest = digest
  end
end
