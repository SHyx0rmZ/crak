require 'crak/parameterized_task'
require 'crak/download_task'
require 'crak/unzip_task'
require 'crak/compilation_task'
require 'tmpdir'
require 'rake/task'

module Crak
  class BuildSourceTask < ParameterizedTask
    def self.define_parameterized_task(params, *args, &block)
      task_name = args.shift.to_s

      task_name_download = Dir::Tmpname.make_tmpname(task_name, 'download')
      task_name_unzip = Dir::Tmpname.make_tmpname(task_name, 'unzip')
      task_name_compile = Dir::Tmpname.make_tmpname(task_name, 'compile')

      download_source = params[:url]
      download_file = Dir.pwd + '/build/dep/' + File.basename(download_source)
      unzip_dir = Dir.pwd + '/build/dep/' + params[:unzipdir]
      compile_builddir = Dir.pwd + '/build/dep/' + params[:builddir]
      compile_outdir = Dir.pwd + '/build/dep/out/' + params[:outdir]
      compile_binaries = params[:binaries]

      DownloadTask.define_task([ task_name_download, { download_source => download_file } ], *args, &block)
      Rake::Task.define_task({ task_name_unzip => unzip_dir }).enhance([ unzip_dir ])
      UnzipTask.define_task([ unzip_dir, download_file ], *args, &block)
      CompilationTask.define_task([ task_name_compile, { builddir: compile_builddir, outdir: compile_outdir, binaries: compile_binaries } ], *args, &block)

      super(params, task_name, *args, &block).enhance([ task_name_download, task_name_unzip, task_name_compile ])
    end
  end
end
