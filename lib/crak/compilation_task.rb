require 'crak/parameterized_task'

module Crak
  class CompilationTask < ParameterizedTask
    def self.define_parameterized_task params, *args, &block
      super(params, *args, &block)
      .enhance { |t| t.execute_compilation }
      .istance_eval { set_parameters(params) }
    end

    def set_parameters(params)
      @outdir = params[:outdir]
      @builddir = params[:builddir]
      @binaries = params[:binaries].map { |binary| File.expand_path(binary, @outdir) }
    end

    def needed?
      @binaries.any? { |binary| !File.exists?(binary) }
    end

    def execute_compilation
      from_dir = Dir.pwd()

      Dir.chdir(@builddir)

      sh %| sh ./configure --prefix="#{@outdir}" |
      sh %| make |
      sh %| make install |

      Dir.chdir(from_dir)
    end
  end
end
