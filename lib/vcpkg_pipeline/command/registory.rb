# frozen_string_literal: true

require 'vcpkg_pipeline/core/log'
require 'vcpkg_pipeline/core/register'

require 'vcpkg_pipeline/command/registory/list'
require 'vcpkg_pipeline/command/registory/add'
require 'vcpkg_pipeline/command/registory/remove'

module VPL
  # Command
  class Command
    # VPL::Command::Registory
    class Registory < Command
      self.abstract_command = true

      self.summary = '注册表管理'
      self.description = <<-DESC
        注册表添加、移除、展示
      DESC
    end
  end
end
