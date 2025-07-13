# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.persisted?
      can :manage, Budget, user: user
      can :manage, Category, user: user
      can :manage, Transaction, user: user
    end
  end
end
