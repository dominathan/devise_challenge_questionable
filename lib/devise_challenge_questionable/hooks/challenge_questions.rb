Warden::Manager.after_authentication do |user, auth, options|
  if user.respond_to?(:need_challenge_questions?)
    auth.session(options[:scope])[:need_challenge_questions] = user.need_challenge_questions?(auth.request)
  end
  if Devise.respond_to?(:token_authentication_key) && auth.env["action_dispatch.request.parameters"].keys.include?(Devise.token_authentication_key.to_s)
    auth.session(options[:scope])[:need_challenge_questions] = false
  end
end