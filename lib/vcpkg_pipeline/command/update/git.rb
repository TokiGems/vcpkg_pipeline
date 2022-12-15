# frozen_string_literal: true

require 'vcpkg_pipeline/core/updater'

module VPL
  class Command
    class Update < Command
      # VPL::Command::Update::Git
      class Git < Update
        self.summary = '更新项目内容'

        self.description = <<-DESC
          更新项目Git内容。
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

          updater.update_git
        end
      end
    end
  end
end
