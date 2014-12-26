require 'crak/download_task'
require 'crak/unzip_task'
require 'crak/compilation_task'
require 'crak/build_source_task'

module Crak
  module DSL
    def download(*args, &block)
      Crak::DownloadTask.define_task(*args, &block)
    end

    def unzip(*args, &block)
      Crak::UnzipTask.define_task(*args, &block)
    end

    def compile(*args, &block)
      Crak::CompilationTask.define_task(*args, &block)
    end

    def build_source(*args, &block)
      Crak::BuildSourceTask.define_task(*args, &block)
    end
  end
end

self.extend Crak::DSL
