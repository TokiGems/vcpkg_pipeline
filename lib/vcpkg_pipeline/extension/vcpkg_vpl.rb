# frozen_string_literal: true

require 'vcpkg_pipeline/extension/vcport_vpl'

require 'vcpkg_pipeline/core/log'

# VCPkg
module VCPkg
  def self.open(path = nil)
    VCPkg::Base.new(path || root)
  end

  def self.hash(zip_path)
    `vcpkg hash #{zip_path}`.sub(/\n/, '')
  end

  def self.format(vcpkg_json_path)
    `vcpkg format-manifest #{vcpkg_json_path}`
  end

  # VCPkg::Base
  class Base
    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def ports
      "#{@path}/ports"
    end

    def publish(vcport)
      name = vcport.vcpkg.name
      version = vcport.vcpkg.version

      git_vcpkg = Git.open(@path)

      git_vcpkg.quick_stash('保存之前的修改')

      port_exist = File.directory? "#{@path}/ports/#{name}"

      `cp -fr #{vcport.port_path} #{ports}/#{name}`
      `vcpkg x-add-version #{name} --vcpkg-root=#{@path}`

      git_vcpkg.add('.')
      git_vcpkg.commit("[#{name}] #{port_exist ? 'Update' : 'Add'} #{version}")
      git_vcpkg.quick_push
    end
  end
end
