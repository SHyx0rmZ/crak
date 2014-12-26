require 'rake/task'

module Crak
  class ParameterizedTask < Rake::Task
    def self.define_task(*args, &block)
      task_name, parameters, *tail = resolve_args(args)

      self.define_parameterized_task(parameters, task_name, *tail, &block)
    end

    def self.define_parameterized_task parameters, *args, &block
      Rake.application.define_task(self, *args, &block)
    end

    def self.resolve_args(args)
      ary = Rake.application.resolve_args(args)

      [ *ary.shift, { ary.shift => ary.shift } ]
    end
  end
end
