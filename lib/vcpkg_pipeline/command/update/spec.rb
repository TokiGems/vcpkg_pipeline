# frozen_string_literal: true

require 'vcpkg_pipeline/core/spec'
require 'vcpkg_pipeline/core/updater'

module VPL
  class Command
    class Update < Command
      # VPL::Command::Update::Spec
      class Spec < Update
        self.summary = '更新项目内容'

        self.description = <<-DESC
          更新项目Spec内容。
        DESC

        self.arguments = [
          CLAide::Argument.new('项目根目录(默认使用当前目录)', false)
        ]

        def self.options
          [].concat(super)
        end

        def initialize(argv)
          @path = argv.shift_argument || Dir.pwd

          super
        end

        def run
          updater = Updater.new(@path)

          updater.update_spec
        end
      end
    end
  end
end
