# frozen_string_literal: true

require 'vcpkg_pipeline/core/register'

module VPL
  class Command
    class Reg < Command
      # VPL::Command::Reg::Remove
      class Remove < Reg
        self.summary = '移除指定注册表'

        self.description = <<-DESC
          移除指定注册表。
        DESC

        self.arguments = [
          CLAide::Argument.new('注册表名称', true)
        ]

        def self.options
          [].concat(super)
        end

        def initialize(argv)
          @name = argv.shift_argument || ''

          super
        end

        def run
          VPL.error('未输入注册表名称') if @name.empty?

          Register.new.remove(@name)
        end
      end
    end
  end
end
