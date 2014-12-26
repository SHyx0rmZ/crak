require 'crak/parameterized_task'

module Crak
  class UnzipTask < ParameterizedTask
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
