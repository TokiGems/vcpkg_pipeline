# frozen_string_literal: true

require 'vcpkg_pipeline/core/scanner'

module VPL
  class Command
    class Scan < Command
      # VPL::Command::Scan::Version
      class Version < Scan
        self.summary = '输出 CMake Version'

        self.description = <<-DESC
            输出 CMake Version。
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
          scanner = Scanner.new(@path)

          puts scanner.spec.version
        end
      end
    end
  end
end
