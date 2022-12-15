# frozen_string_literal: true

require 'vcpkg_pipeline/extension/vcpkg_vpl'

require 'vcpkg_pipeline/core/scanner'

module VPL
  # VPL::Updater
  class Updater
    attr_accessor :path, :scanner

    def initialize(path)
      @path = path
      @scanner = Scanner.new(path)
    end

    def update_spec(version = nil)
      @scanner.spec.version_update(version)
      @scanner.scan_spec
    end

    def update_cmake
      @scanner.cmake.version_update(
        @scanner.spec.version
      )
    end

    def update_vcport_vcpkg
      vcpkg = @scanner.vcport.vcpkg
      vcpkg.version_update(@scanner.spec.version)
      VCPkg.format(vcpkg.content_path)
    end

    def update_vcport_portfile(output_path = nil)
      distfile_hash = @scanner.spec.distfile_package(output_path)
      @scanner.vcport.portfile.download_distfile_update(
        @scanner.spec.disturl,
        @scanner.spec.distfile_name,
        distfile_hash
      )
    end

    def update_vcport(output_path = nil)
      update_vcport_vcpkg
      update_vcport_portfile(output_path)
    end

    def update_git
      @scanner.git.quick_push(
        @scanner.spec.version
      )
    end

    def update_all(version = nil, output_path = nil)
      @scanner.git.reset

      update_spec(version)
      @scanner.git.add('*.vplspec')
      update_cmake
      @scanner.git.add('CMakeLists.txt')
      update_vcport(output_path)
      @scanner.git.add('vcport')

      @scanner.git.commit(@scanner.cmake.version)

      update_git
    end
  end
end
