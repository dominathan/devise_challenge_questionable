module ActionDispatch::Routing
  class Mapper
    protected

      def devise_challenge_question(mapping, controllers)
        resource :challenge_question, :only => [:show, :new, :create, :edit, :update], :path => mapping.path_names[:challenge_question], :controller => controllers[:challenge_questions] do
          put :authenticate, :path => mapping.path_names[:authenticate]
          get :manage, :path => mapping.path_names[:manage]
          get :forgot, :path => mapping.path_names[:forgot]
          get :max_challenge_question_attempts_reached, :path => mapping.path_names[:max_challenge_question_attempts_reached]
        end
      end
  end
end