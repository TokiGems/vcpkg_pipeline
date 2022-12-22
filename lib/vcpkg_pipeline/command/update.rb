# frozen_string_literal: true

require 'vcpkg_pipeline/core/updater'

require 'vcpkg_pipeline/command/update/spec'
require 'vcpkg_pipeline/command/update/cmake'
require 'vcpkg_pipeline/command/update/vcport'
require 'vcpkg_pipeline/command/update/git'
require 'vcpkg_pipeline/command/update/all'

module VPL
  class Command
    # VPL::Command::Update
    class Update < Command
      self.abstract_command = true

      self.summary = '项目扫描'
      self.description = <<-DESC
        获取项目信息及关键参数
      DESC
    end
  end
end
