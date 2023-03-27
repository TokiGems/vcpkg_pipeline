# frozen_string_literal: true

require 'git'

require 'vcpkg_pipeline/extension/dir_vpl'

require 'vcpkg_pipeline/core/log'

module VPL
  class Command
    # VPL::Command::New
    class New < Command
      self.summary = '创建新项目'

      self.description = <<-DESC
        根据TokiHunter的最佳实践, 为名为 'NAME' 的新Pod库的开发创建一个脚手架。
        如果未指定 '--template-url', 默认使用 'https://github.com/TKCMake/vcport-template.git'。
      DESC

      self.arguments = [
        CLAide::Argument.new('项目名字', true)
      ]

      def self.options
        [
          ['--template-url=https://github.com/TKCMake/vcport-template.git', 'vcport模版地址']
        ].concat(super).concat(options_extension)
      end

      def initialize(argv)
        @name = argv.shift_argument || ''

        @template = argv.option('template-url', '').split(',').first
        @template ||= 'https://github.com/TKCMake/vcport-template.git'

        super
      end

      def replacements
        {
          'PT_PORT_NAME' => @name,
          'PT_USER_NAME' => Git.global_config('user.name')
        }
      end

      def run
        VPL.error('未输入port名称') if @name.empty?

        Git.clone(@template, @name, depth: 1)

        Dir.replace_all(@name, replacements)

        git = Git.open(@name)
        git.remote.remove
        git.add('.')
        git.commit("init #{@name}", amend: true)
      end
    end
  end
end
