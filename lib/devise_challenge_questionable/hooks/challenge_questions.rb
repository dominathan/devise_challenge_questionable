Warden::Manager.after_authentication do |user, auth, options|
  if user.respond_to?(:need_challenge_questions?)
    auth.session(options[:scope])[:need_challenge_questions] = user.need_challenge_questions?(auth.request)
  end
end
