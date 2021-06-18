# frozen_string_literal: true
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    if user.full_control? 
      can :manage, Admin
      can :manage, Franchise
      can :manage, Accountant
      can :manage, Insurance
      can :manage, WebsitePreference
      can :manage, Financial
      can :manage, TransactionCode
      can :manage, PrpTransaction
      can :manage, Remittance
      can :manage, FranchiseDocument
      can :manage, Invoice
      can :manage, User
      can :masquerade, User
      can [:read, :create], BankPayment
      can [:edit], BankPayment, status: "pending"
      can [:update], BankPayment, status: "pending"
      can [:destroy], BankPayment,  status: "pending"
      can [:delete], BankPayment, status: ["pending","error"]
      can :manage,  CheckPayment 
    else
      can :read, :all
      # can :read, Franchise
      # can :read, Accountant
      # can :read, Insurance
      # can :read, WebsitePreference
      # can :read, Financial
      # can :read, Invoice
      # can :read, WebsitePreference
      # can :read, Financial
      # can :read, TransactionCode
      # can :read, PrpTransaction
      # can :read, Remittance
      # can :read, FranchiseDocument
      # can :read, Invoice
      # can :read, User
      # can :masquerade, User
      # can :read, BankPayment
      # can :read,  CheckPayment 
    end    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
