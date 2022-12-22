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
    attr_accessor :path, :git

    def initialize(path)
      @path = path

      @git = Git.open(@path)
    end

    def ports
      "#{@path}/ports"
    end

    def copy_port(vcport, commit_message)
      name = vcport.vcpkg.name

      `cp #{vcport.port_path}/* #{ports}/#{name}`
      @git.add('.')
      @git.commit(commit_message)
    end

    def add_version(vcport, commit_message)
      name = vcport.vcpkg.name

      `vcpkg x-add-version #{name} --vcpkg-root=#{@path}`
      @git.add('.')
      @git.commit(commit_message, amend: true)
    end

    def publish(vcport)
      name = vcport.vcpkg.name

      @git.quick_stash('保存之前的修改')

      port_exist = File.directory? "#{@path}/ports/#{name}"
      `mkdir -p #{@path}/ports/#{name}` unless port_exist

      commit_message = "[#{name}] #{port_exist ? 'Update' : 'Add'} #{vcport.vcpkg.version}"

      copy_port(vcport, commit_message)
      add_version(vcport, commit_message)

      @git.quick_push
    end
  end
end
