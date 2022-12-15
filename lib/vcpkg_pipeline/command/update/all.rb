# frozen_string_literal: true

require 'vcpkg_pipeline/core/updater'

module VPL
  class Command
    class Update < Command
      # VPL::Command::Update::All
      class All < Update
        self.summary = '更新项目内容'

        self.description = <<-DESC
          更新项目CMake、VCPort、Git Tag内容。
        DESC

        self.arguments = [
          CLAide::Argument.new('项目根目录(默认使用当前目录)', false)
        ]

        def self.options
          [
            ['--version=x.x.x', '新版本号。(默认使用patch+1)'],
            ['--output=./', '项目打包的输出目录。(默认使用项目 根目录/build)']
          ].concat(super)
        end

        def initialize(argv)
          @path = argv.shift_argument || Dir.pwd

          @new_version = argv.option('version', '').split(',').first
          @output_path = argv.option('output', '').split(',').first
          super
        end

        def run
          updater = Updater.new(@path)

          updater.update_all(@new_version, @output_path)
        end
      end
    end
  end
end
