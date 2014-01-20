# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_challenge_questionable/version"

Gem::Specification.new do |s|
  s.name        = "devise_challenge_questionable"
  s.version     = DeviseChallengeQuestionable::VERSION.dup
  s.authors     = ["Andrew Kennedy"]
  s.email       = ["andrew@akennedy.io"]
  s.homepage    = "https://github.com/akennedy/devise_challenge_questionable"
  s.summary     = %q{Challenge question plugin for devise}
  s.description = <<-EOF
    ### Features ###
    * configure max challenge question attempts
    * per user level control if he really need challenge questions
  EOF

  s.rubyforge_project = "devise_challenge_questionable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rails', '>= 3.0.20'
  s.add_runtime_dependency 'devise'
  s.add_runtime_dependency 'randexp'

  s.add_development_dependency 'bundler'
end
