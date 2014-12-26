require 'crak/download_task'

module Crak
  module DSL
    def download(*args, &block)
      Crak::DownloadTask.define_task(*args, &block)
    end
  end
end

self.extend Crak::DSL
