# frozen_string_literal: true

require 'json'

require 'vcpkg_pipeline/extension/string_vpl'

require 'vcpkg_pipeline/core/log'

# VCPort
module VCPort
  def self.open(path)
    VCPort::Base.new(path)
  end

  # VCPort::Base
  class Base
    attr_accessor :path, :port_path, :vcpkg, :portfile

    def initialize(path)
      @path = path
      @port_path = "#{path}/vcport"
      VPL.error("#{@port_path} Not Found") unless File.directory? @port_path

      @vcpkg = VCPkg.new(@port_path)
      @portfile = Portfile.new(@port_path)
    end

    def to_s
      "#{vcpkg}\n#{portfile}"
    end

    # VCPort::Base::VCPkg
    class VCPkg
      attr_accessor :path, :content_path, :content, :json, :name, :version

      def initialize(path)
        @path = path
        @content_path = "#{path}/vcpkg.json"

        VPL.error("#{@content_path} Not Found") unless File.exist? @content_path
        @content = File.read(@content_path)

        parse_content(@content)
      end

      def parse_content(content)
        @json = JSON.parse(content)
        @name = @json['name']
        @version = @json['version']
      end

      def version_update(new_version)
        @json['version'] = new_version
        File.write(@content_path, JSON.dump(@json))
        VPL.info("Port 版本号更新: #{@version} -> #{new_version}")
      end

      def to_s
        "#{json['name']}-#{json['version']}"
      end
    end

    # VCPort::Base::Portfile
    class Portfile
      attr_accessor :path, :content_path, :content, :download_distfile, :url, :filename, :hash

      def initialize(path)
        @path = path
        @content_path = "#{path}/portfile.cmake"

        VPL.error("#{@content_path} Not Found") unless File.exist? @content_path
        @content = File.read(@content_path)

        parse_content(@content)
      end

      def parse_content(content)
        content.each_line(')') { |piece| parse_download_distfile(piece) }
      end

      def parse_download_distfile(piece)
        return unless piece.include? 'vcpkg_download_distfile'

        @download_distfile = piece

        clean_download_distfile = piece.clean
        parse_download_distfile_url(clean_download_distfile)
        parse_download_distfile_filename(clean_download_distfile)
        parse_download_distfile_hash(clean_download_distfile)
      end

      def parse_download_distfile_url(clean_download_distfile)
        regex_url = /URLS "([^ ]*)" /
        regex_url.match(clean_download_distfile)
        @url = Regexp.last_match(1)
      end

      def parse_download_distfile_filename(clean_download_distfile)
        regex_filename = /FILENAME "([^ ]*)" /
        regex_filename.match(clean_download_distfile)
        @filename = Regexp.last_match(1)
      end

      def parse_download_distfile_hash(clean_download_distfile)
        regex_hash = /SHA512 ([^ ]*) /
        regex_hash.match(clean_download_distfile)
        @hash = Regexp.last_match(1)
      end

      def download_distfile_update(new_url, new_filename, new_hash)
        new_download_distfile = @download_distfile
        new_download_distfile = new_download_distfile.sub("URLS \"#{@url}\"", "URLS \"#{new_url}\"")
        new_download_distfile = new_download_distfile.sub("FILENAME \"#{@filename}\"", "FILENAME \"#{new_filename}\"")
        new_download_distfile = new_download_distfile.sub("SHA512 #{@hash}", "SHA512 #{new_hash}")
        File.write(@content_path, @content.sub(@download_distfile, new_download_distfile))
        VPL.info("Port 下载文件信息更新: \
          \n URLS #{@url} -> #{new_url}\
          \n FILENAME #{@filename} -> #{new_filename}\
          \n SHA512 #{@hash} -> #{new_hash}\
        ")
      end

      def to_s
        "#{@url} -> #{@filename}"
      end
    end
  end
end
