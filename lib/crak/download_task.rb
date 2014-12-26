require 'rake/task'
require 'net/http'
require 'fileutils'
require 'uri'
require 'time'

module Crak
  class DownloadTask < Rake::Task
    def self.define_task *args, &block
      task_name, download_data, *rest = resolve_args(args)

      unless download_data.is_a?(Hash)
        fail "Don't know what to download in task '#{task_name}'"
      end

      task = super task_name, *rest, &block

      task.set_download_data(download_data)
      task.enhance { |t| t.execute_download }
    end

    def self.resolve_args(args)
      ary = Rake.application.resolve_args(args)

      [ *ary.shift, { ary.shift => ary.shift } ]
    end

    def set_download_data data
      @url = URI(data.keys.first)
      @file_name = data.values.first
    end

    def enhance deps = nil, &block
      super deps, &block
    end

    def needed?
      return true unless File.exists?(@file_name)

      request = Net::HTTP::Get.new(@url)
      request['If-Modified-Since'] = File.stat(@file_name).mtime.rfc2822

      response = Net::HTTP.start(@url.hostname, @url.port) do |http|
        http.request(request)
      end

      !response.is_a?(Net::HTTPNotModified)
    end


    def execute_download
      response = Net::HTTP.get_response(@url)

      fail "Could not complete download in task '#{@name}': #{@url}" unless response.kind_of?(Net::HTTPSuccess)

      FileUtils.mkdir_p(File.dirname(@file_name))
      File.write(@file_name, response.body, mode: 'wb')
    end
  end
end
