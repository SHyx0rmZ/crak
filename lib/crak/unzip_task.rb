require 'crak/parameterized_task'
require 'rake/file_utils_ext'

module Crak
  class UnzipTask < ParameterizedTask
    include Rake::FileUtilsExt
    private(*FileUtils.instance_methods(false))
    private(*Rake::FileUtilsExt.instance_methods(false))

    def self.define_parameterized_task params, *args, &block
      super(params, *args, &block)
          .enhance { |t| t.execute_unzip }
          .instance_eval { @archive = params }
    end

    def needed?
      !Dir.exists?(@name)
    end

    def execute_unzip
      verbose(false) do
        sh %| unzip -qq -d #{File.dirname(@name)} #{@archive} |
      end
    end
  end
end
