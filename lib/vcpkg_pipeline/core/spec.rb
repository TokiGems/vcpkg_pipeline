# frozen_string_literal: true

require 'vcpkg_pipeline/extension/vcpkg_vpl'

require 'vcpkg_pipeline/core/log'

module VPL
  # VPL::Spec
  class Spec
    # spec file
    attr_accessor :path, :content_path, :content

    # port info
    attr_accessor :name, :version, :user, :homepage, :description, :dependencies

    # dist info
    attr_accessor :sources, :disturl

    def self.eval_vplspec(content, content_path)
      instance_eval(content)
    rescue RescueException => e
      VPL.error("Invalid `#{content_path.basename}` file: #{e.message}")
    end

    def self.load(path)
      content_path_list = Dir["#{path}/*.vplspec"]
      VPL.error('未找到或存在多个 *.vplspec 文件') if content_path_list.empty? || content_path_list.count > 1
      content_path = content_path_list.first
      content = File.read(content_path)

      spec = eval_vplspec(content, content_path)
      spec.path = path
      spec.content_path = content_path
      spec.content = content
      spec
    end

    def initialize
      yield self if block_given?
    end

    def distfile_name
      "#{name}-#{version}.zip"
    end

    def distfile_package(output_path = nil)
      output_path ||= '.'
      distfile_path = "#{output_path}/#{distfile_name}"

      zip_sources = []
      @sources.each do |source|
        zip_sources += Dir[source]
      end
      VPL.info(zip_sources.join('\n'))
      `zip #{distfile_path} #{zip_sources.join(' ')}`

      VPL.error("Dist包 打包失败: #{distfile_path}") unless File.exist? distfile_path
      VCPkg.hash(distfile_path)
    end

    def write(property, value)
      VPL.info("写入 #{File.basename(@content_path)} : #{property} = #{value}")

      new_content = @content.gsub!(/(.*.#{property}.*=.*)('.*')/, "\\1'#{value}'")
      File.write(@content_path, new_content)
    end

    def version_increased
      versions = @version.split('.')

      new_version_last = (versions.last.to_i + 1).to_s
      versions.pop
      versions.push(new_version_last)

      versions.join('.')
    end

    def version_update(new_version = nil)
      new_version ||= version_increased
      write('version', new_version)
    end

    def to_s
      "#{@name} (#{@version})\
      \nuser: #{@user}\
      \nhomepage: #{@homepage}\
      \ndescription: #{@description}\
      \nsources: #{@sources}\
      \ndependencies: #{@dependencies}"
    end
  end
end
