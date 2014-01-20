module ActionDispatch::Routing
  class Mapper
    protected

      def devise_challenge_question(mapping, controllers)
        resource :challenge_question, :only => [:show, :update], :path => mapping.path_names[:challenge_question], :controller => controllers[:challenge_questions]
      end
  end
end