class Ability
  include CanCan::Ability

  def initialize(user)

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # everyone can do these things, even non-logged in
    can :read, :all

    if user

      # managing your own user settings
      can :update, User, :id => user.id

      can :create, Site # but can't set the status

      can :create, Watch
      can :manage, Watch, :user_id => user.id

      if user.has_role? :admin
        can :manage, :all
        can :set_status, Site
      end

    end
  end
end
