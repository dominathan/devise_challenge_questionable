module ActionDispatch::Routing
  class Mapper
    protected

      def devise_challenge_question(mapping, controllers)
        resource :challenge_question, :only => [:show, :authenticate, :new, :create, :edit, :update], :path => mapping.path_names[:challenge_question], :controller => controllers[:challenge_questions] do
          put :authenticate, :path => mapping.path_names[:authenticate]
        end
      end
  end
end