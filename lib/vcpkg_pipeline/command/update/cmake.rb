# frozen_string_literal: true

require 'vcpkg_pipeline/core/updater'

module VPL
  class Command
    class Update < Command
      # VPL::Command::Update::CMake
      class CMake < Update
        self.summary = '更新项目内容'

        self.description = <<-DESC
          更新项目CMake内容。
        DESC

        self.arguments = [
          CLAide::Argument.new('项目根目录(默认使用当前目录)', false)
        ]

        def self.options
          [
            ['--version=x.x.x', '新版本号。(默认使用patch+1)']
          ].concat(super)
        end

        def initialize(argv)
          @path = argv.shift_argument || Dir.pwd

          @new_version = argv.option('version', '').split(',').first
          super
        end

        def run
          updater = Updater.new(@path)

          updater.update_cmake(@new_version)
        end
      end
    end
  end
end
