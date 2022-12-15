# frozen_string_literal: true

require 'vcpkg_pipeline/core/scanner'

module VPL
  class Command
    class Scan < Command
      # VPL::Command::Scan::All
      class All < Scan
        self.summary = '输出项目完整信息'

        self.description = <<-DESC
            输出项目完整信息。
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

          VPL.info("Release: #{ENV['Release'] ? true : false}")
          VPL.info("Git: #{scanner.git}")
          VPL.info("CMake: #{scanner.cmake}")
          VPL.info("VCPort: #{scanner.vcport}")
          VPL.info("Spec: #{scanner.spec}")
        end
      end
    end
  end
end
