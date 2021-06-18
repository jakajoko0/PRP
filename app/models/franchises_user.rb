class FranchisesUser
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :email , :role , :franchise_id

  def persisted?
    false
  end

end

	
