# frozen_string_literal: true

require 'vcpkg_pipeline/extension/vcport_vpl'

require 'vcpkg_pipeline/core/log'

# VCPkg
module VCPkg
  def self.root
    `echo $VCPKG_ROOT`.sub(/\n/, '')
  end

  def self.ports
    "#{root}/ports"
  end

  def self.hash(zip_path)
    `vcpkg hash #{zip_path}`.sub(/\n/, '')
  end

  def self.format(vcpkg_json_path)
    `vcpkg format-manifest #{vcpkg_json_path}`
  end

  def self.publish(vcport)
    name = vcport.vcpkg.name
    version = vcport.vcpkg.version

    git_vcpkg = Git.open(root)

    git_vcpkg.quick_stash('保存之前的修改')

    port_exist = File.directory? "#{VCPkg.root}/ports/#{name}"

    `cp -fr #{vcport.port_path} #{ports}`
    `vcpkg x-add-version #{name}`

    git_vcpkg.add('.')
    git_vcpkg.commit("[#{name}] #{port_exist ? 'Update' : 'Add'} #{version}")
    git_vcpkg.quick_push
  end
end
