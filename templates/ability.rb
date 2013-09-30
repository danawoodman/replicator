class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all
      # can :read, Page do |page|
      #   page.published?
      # end
    end
  end
end
