class Ability
  include CanCan::Ability

  def initialize(user)

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # everyone can do these things, even non-logged in
    can :read, :all

    if user

      # managing your own user settings
      can :update, User, :id => user.id

      if user.has_role? :admin
        can :manage, :all
      end

    end
  end
end
