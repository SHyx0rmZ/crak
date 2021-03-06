require 'net/http'
require 'fileutils'
require 'uri'
require 'time'
require 'crak/parameterized_task'

module Crak
  class DownloadTask < ParameterizedTask
    def self.define_parameterized_task parameters, *args, &block
      unless parameters.is_a?(Hash)
        fail "Don't know what to download in task '#{args.first}'"
      end

      task = super(parameters, *args, &block)

      task.set_download_data(parameters)
      task.enhance { |t| t.execute_download }
    end

    def set_download_data data
      @url = URI(data.keys.first)
      @file_name = data.values.first
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
