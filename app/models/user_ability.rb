class UserAbility
  include CanCan::Ability

  def initialize(user)

    if user.full_control? 
      can [:read, :update], Franchise, id: user.franchise_id
      can :manage, BankAccount, franchise_id: user.franchise_id
      can :manage, CreditCard, franchise_id: user.franchise_id
      can [:read, :update], WebsitePreference, franchise_id: user.franchise_id
      can :manage, Financial, franchise_id: user.franchise_id
      can [:read, :create],  Remittance, franchise_id: user.franchise_id
      can [:edit], Remittance, franchise_id: user.franchise_id , status: "pending"
      can [:update],  Remittance, franchise_id: user.franchise_id, status: "pending"
      can [:destroy], Remittance, franchise_id: user.franchise_id, status: "pending"
      can [:delete], Remittance, franchise_id: user.franchise_id, status: "pending"
      can :manage, FranchiseDocument, franchise_id: user.franchise_id
      can [:read, :create],  Invoice, franchise_id: user.franchise_id
      can [:edit], Invoice, franchise_id: user.franchise_id , paid: 0, admin_generated: 0
      can [:update],  Invoice, franchise_id: user.franchise_id, paid: 0, admin_generated: 0
      can [:destroy], Invoice, franchise_id: user.franchise_id, paid: 0 ,admin_generated: 0 
      can [:delete], Invoice, franchise_id: user.franchise_id, paid: 0, admin_generated: 0
      can :manage, DepositTracking, franchise_id: user.franchise_id
    end    
  end
end
