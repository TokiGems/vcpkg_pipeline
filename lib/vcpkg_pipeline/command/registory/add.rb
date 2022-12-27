# frozen_string_literal: true

require 'vcpkg_pipeline/core/register'

module VPL
  class Command
    class Registory < Command
      # VPL::Command::Registory::Add
      class Add < Registory
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

          VPL.error('未输入注册表名称') if @name.empty?
          VPL.error('未输入注册表地址') if @url.empty?

          super
        end

        def run
          Register.new.add(@name, @url)
        end
      end
    end
  end
end
