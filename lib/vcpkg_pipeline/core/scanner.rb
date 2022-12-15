# frozen_string_literal: true

require 'git'

require 'vcpkg_pipeline/extension/cmake_vpl'
require 'vcpkg_pipeline/extension/vcport_vpl'
require 'vcpkg_pipeline/extension/vcpkg_vpl'
require 'vcpkg_pipeline/extension/git_vpl'

require 'vcpkg_pipeline/core/spec'

module VPL
  # VPL::Scanner
  class Scanner
    attr_accessor :path, :spec, :git, :cmake, :vcport

    def initialize(path)
      @path = path
      @spec = Spec.load(path)
      @cmake = CMake.open(path)
      @vcport = VCPort.open(path)
      @git = Git.open(path)
    end

    def scan_spec
      @spec = Spec.load(path)
    end
  end
end
