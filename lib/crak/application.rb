require 'rake'

require 'crak/dsl_definition'
require 'crak/version'

module Crak
  class Application < Rake::Application
    include Crak::DSL

    def standard_rake_options
      options = super
      version_option = options.select { |option| option.first.eql?('--version') } .first
      ruby_version_proc = version_option.last

      version_option[-1] = lambda do |ruby_version_proc, value|
        puts "crak, version #{Crak::VERSION}"

        ruby_version_proc.call(value)
      end.curry.(ruby_version_proc)

      options
    end
  end
end
