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
      can :update, Site do |s|
        s.added_by_user_id == user.id && s.status == 'unknown'
      end
      can :post_to_site, Site do |s|
        s.watches.find_by_user_id(user.id)
      end

      can :create, Watch
      can :manage, Watch, :user_id => user.id

      if user.has_role? :admin
        can :manage, :all
        can :set_status, Site
        can :post_to_site, Site
      end

    end
  end
end
