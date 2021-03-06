class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki
  
  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end
  
  def show?
    if wiki.private
      user.admin? || wiki.collaborators.users.ids.include?(user.id) || user.id == wiki.user_id
    else
      user.present?
    end
  end
  
  def update?
    if wiki.private
      user.admin? || wiki.collaborators.users.ids.include?(user.id) || user.id == wiki.user_id
    else
      user.present?
    end
  end
  
  def destroy?
    user.admin? || user.id == wiki.user_id
  end
=begin  
  class Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      @user = user
      @scope = scope
    end
    
    def resolve
      if user.admin? || user.premium?
        scope.all
      else
        scope.where(private: false)
      end
    end
  end
=end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
          @user = user
          @scope = scope
      end

      def resolve
          wikis = []
          if user.admin?
              wikis = scope.all
          else
              all_wikis = scope.all
              all_wikis.each do |wiki|
                  if !wiki.private || wiki.user_id == user.id || wiki.collaborators.users.ids.include?(user.id)
                      wikis << wiki
                  end
              end
          end
          wikis
      end
    end
end