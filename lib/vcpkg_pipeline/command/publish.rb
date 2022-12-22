# frozen_string_literal: true

require 'vcpkg_pipeline/extension/vcpkg_vpl'

require 'vcpkg_pipeline/core/log'
require 'vcpkg_pipeline/core/scanner'

require 'vcpkg_pipeline/command/update'
require 'vcpkg_pipeline/command/update/all'

module VPL
  class Command
    # VPL::Command::Publish
    class Publish < Command
      self.summary = '项目发布'
      self.description = <<-DESC
        整合项目发布流程
      DESC
      self.arguments = [
        CLAide::Argument.new('项目根目录(默认使用当前目录)', false)
      ]
      def self.options
        [
          ['--registry=.', '指定vcpkg的registry目录, 不可为空']
        ].concat(super).concat(options_extension)
      end

      def self.options_extension_hash
        Hash[
          'update' => Update::All.options,
        ]
      end

      def initialize(argv)
        @path = argv.shift_argument || Dir.pwd

        @registry = argv.option('registry', '').split(',').first
        super
      end

      def run
        VPL.error("registry目录异常: #{@registry}") unless File.directory? @registry

        Update::All.run([@path] + argv_extension['update'])

        scanner = Scanner.new(@path)

        vcpkg = VCPkg.open(@registry)
        vcpkg.publish(scanner.vcport)
      end
    end
  end
end
