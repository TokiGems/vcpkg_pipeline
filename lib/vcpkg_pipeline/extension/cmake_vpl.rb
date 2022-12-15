# frozen_string_literal: true

require 'vcpkg_pipeline/extension/string_vpl'
require 'vcpkg_pipeline/extension/dir_vpl'

require 'vcpkg_pipeline/core/log'

# CMake
module CMake
  def self.open(path)
    CMake::Base.new(path)
  end

  # CMake::Base
  class Base
    attr_accessor :path, :content_path, :content, :project, :name, :version

    def initialize(path)
      @path = path
      @content_path = "#{path}/CMakeLists.txt"

      VPL.error("#{@content_path} Not Found") unless File.exist? @content_path
      @content = File.read(@content_path)

      parse_content(@content)
    end

    def parse_content(content)
      content.each_line(')') { |piece| parse_project(piece) }
    end

    def parse_project(piece)
      return unless piece.include? 'project'

      @project = piece

      clean_project = piece.clean
      parse_project_name(clean_project)
      parse_project_version(clean_project)
    end

    def parse_project_name(clean_project)
      regex_name = /project \( ([^ ]*) /
      regex_name.match(clean_project)
      @name = Regexp.last_match(1)
    end

    def parse_project_version(clean_project)
      regex_version = /VERSION ([^ ]*) /
      regex_version.match(clean_project)
      @version = Regexp.last_match(1)
    end

    def version_increased
      regex_version = /([^.]*)\.([^.]*)\.([^.]*)\.*([^.]*)/
      regex_version.match(@version)

      new_patch = Regexp.last_match(3).to_i + 1
      "#{Regexp.last_match(1)}.#{Regexp.last_match(2)}.#{new_patch}#{Regexp.last_match(4)}"
    end

    def version_update(new_version = nil)
      new_version ||= version_increased

      new_project = @project.sub(@version, new_version)
      new_content = @content.sub(@project, new_project)
      File.write(@content_path, new_content)

      @content = new_content
      @project = new_project
      @version = new_version
    end

    def to_s
      "#{name}-#{version}"
    end
  end
end
