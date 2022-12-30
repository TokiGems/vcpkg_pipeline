# frozen_string_literal: true

require 'vcpkg_pipeline/core/log'
require 'vcpkg_pipeline/core/register'

require 'vcpkg_pipeline/command/reg/list'
require 'vcpkg_pipeline/command/reg/add'
require 'vcpkg_pipeline/command/reg/remove'

module VPL
  # Command
  class Command
    # VPL::Command::Reg
    class Reg < Command
      self.abstract_command = true

      self.summary = '注册表管理'
      self.description = <<-DESC
        注册表添加、移除、展示
      DESC
    end
  end
end
