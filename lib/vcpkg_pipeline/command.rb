# frozen_string_literal: true

require 'claide'

module VPL
  # VPL::Command
  class Command < CLAide::Command
    require 'vcpkg_pipeline/command/new'
    require 'vcpkg_pipeline/command/scan'
    require 'vcpkg_pipeline/command/update'
    require 'vcpkg_pipeline/command/publish'
    require 'vcpkg_pipeline/command/reg'

    self.abstract_command = true
    self.command = 'vpl'
    self.description = 'vcpkg-Pipeline 是 vcpkg 的流水线工具'

    def self.options
      [
        ['--help', '展示改命令的介绍面板']
      ]
    end

    def self.options_extension
      options = []
      options_extension_hash.each do |key, options_extension|
        options_extension.each do |option_extension|
          options << [option_extension.first.gsub(/(--)(.*)/, "\\1#{key}-\\2"), option_extension.last]
        end
      end
      options
    end

    def self.options_extension_hash
      Hash[]
    end

    def self.run(argv)
      ensure_not_root_or_allowed! argv
      verify_minimum_git_version!
      verify_xcode_license_approved!

      super(argv)
    end

    #
    # 确保root用户
    #
    # @return [void]
    #
    def self.ensure_not_root_or_allowed!(argv, uid = Process.uid, is_windows = Gem.win_platform?)
      root_allowed = argv.include?('--allow-root')
      help! 'You cannot run vcpkg-Pipeline as root' unless root_allowed || uid != 0 || is_windows
    end

    # 读取Git版本号, 返回一个新的 {Gem::Version} 实例
    #
    # @return [Gem::Version]
    #
    def self.git_version
      raw_version = `git version`
      unless (match = raw_version.scan(/\d+\.\d+\.\d+/).first)
        raise "Failed to extract git version from `git --version` (#{raw_version.inspect})"
      end

      Gem::Version.new(match)
    end

    # 检查Git版本号是否低于 1.8.5
    #
    # @raise Git版本号低于 1.8.5
    #
    # @return [void]
    #
    def self.verify_minimum_git_version!
      return unless git_version < Gem::Version.new('1.8.5')

      raise 'You need at least git version 1.8.5 to use vcpkg-Pipeline'
    end

    #
    # 检查xcode许可是否被批准
    #
    # @return [void]
    #
    def self.verify_xcode_license_approved!
      return unless `/usr/bin/xcrun clang 2>&1` =~ /license/ && !$?.success?

      raise 'You have not agreed to the Xcode license, which ' \
          'you must do to use vcpkg. Agree to the license by running: ' \
          '`xcodebuild -license`'
    end

    def initialize(argv)
      @argv_extension = {}
      self.class.options_extension_hash.each_key do |key|
        @argv_extension[key] = []
        self.class.options.each do |option|
          name = option.first
          next unless name.include?(key)

          is_option = name.include? '='
          if is_option
            option = name.gsub(/(--)(.*)(=.*)/, '\\2')
            value = argv.option(option, '')
            unless value.empty?
              @argv_extension[key] << name.gsub(/(--.*=)(.*)/, "\\1#{value}").gsub("#{key}-",
                                                                                   '')
            end
          else
            flag = name.gsub(/(--)(.*)/, '\\2')
            value = argv.flag?(flag)
            @argv_extension[key] << name.gsub("#{key}-", '') if value
          end
        end
      end

      super
    end

    attr_reader :argv_extension
  end
end
