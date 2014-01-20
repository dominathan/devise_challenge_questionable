module DeviseChallengeQuestionable
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseChallengeQuestionable::Controllers::Helpers
    end
  end
end
