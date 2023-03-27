# frozen_string_literal: true

require 'vcpkg_pipeline/core/register'

module VPL
  class Command
    class Reg < Command
      # VPL::Command::Reg::Add
      class Add < Reg
        self.summary = '添加新的注册表'

        self.description = <<-DESC
          添加新的注册表。
        DESC

        self.arguments = [
          CLAide::Argument.new('注册表名称', true),
          CLAide::Argument.new('注册表地址', true)
        ]

        def self.options
          [].concat(super)
        end

        def initialize(argv)
          @name = argv.shift_argument || ''
          @url = argv.shift_argument || ''

          super
        end

        def run
          VPL.error('未输入注册表名称') if @name.empty?
          VPL.error('未输入注册表地址') if @url.empty?

          Register.new.add(@name, @url)
        end
      end
    end
  end
end
