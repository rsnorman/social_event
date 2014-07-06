group :development do
  guard 'bundler' do
    watch('Gemfile')
  end

  guard 'spork' do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.*\.rb$})
    watch(%r{^config/initializers/.*\.rb$})
    watch('Gemfile.lock')
    watch('spec/spec_helper.rb') { :rspec  }
  end

  guard 'rspec', :version => 2,:cli => '--drb', :rspec_cli => '--drb --colour --format Fuubar --tag focus --tag ~js_fixture', :all_after_pass => false, :all_on_start => false do
    # monitor models
    watch(%r{^app/models/(.+)\.rb$})                    { |m| "spec/models/#{m[1]}_spec.rb"}
    watch(%r{^app/controllers/(.+)\.rb$})                    { |m| "spec/controllers/#{m[1]}_spec.rb"}

    # monitor controllers
    #watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    #watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"] }

    # monitor routing
    watch('config/routes.rb')                           { "spec/routing" }

    # monitor lib files
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }

    # monitor all spec files
    watch(%r{^spec/.+_spec\.rb$})
  end
end
