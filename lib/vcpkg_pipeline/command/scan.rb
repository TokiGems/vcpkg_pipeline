# frozen_string_literal: true

require 'vcpkg_pipeline/core/log'
require 'vcpkg_pipeline/core/scanner'

require 'vcpkg_pipeline/command/scan/all'
require 'vcpkg_pipeline/command/scan/name'
require 'vcpkg_pipeline/command/scan/version'
require 'vcpkg_pipeline/command/scan/remote'
require 'vcpkg_pipeline/command/scan/branch'

module VPL
  # Command
  class Command
    # VPL::Command::Scan
    class Scan < Command
      self.abstract_command = true

      self.summary = '项目扫描'
      self.description = <<-DESC
        获取项目的关键参数
      DESC
    end
  end
end
