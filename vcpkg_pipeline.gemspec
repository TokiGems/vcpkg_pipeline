# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'vcpkg_pipeline'
  s.version     = '0.1.1'
  s.summary     = 'vcpkg 流水线工具'
  s.description = '为 vcpkg 开发设计的集项目构建、发布为一体的强大工具'
  s.authors     = ['郑贤达']
  s.email       = 'zhengxianda0512@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/TokiGems/vcpkg_pipeline'
  s.license     = 'MIT'

  s.executables = ['vpl']

  s.add_runtime_dependency 'claide',               '>= 1.0.2', '< 2.0'     # 命令行工具
  s.add_runtime_dependency 'git',                  '>= 1.8.1', '< 2.0'     # Git项目管理工具
  s.add_runtime_dependency 'json',                 '>= 2.6.1', '< 3.0'     # JSON读写工具

  ## Make sure you can build the gem on older versions of RubyGems too:
  s.required_rubygems_version = '>=1.6.2'
  s.required_ruby_version = '>=2.6.0'
end
