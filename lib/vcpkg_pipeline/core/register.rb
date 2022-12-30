# frozen_string_literal: true

require 'git'

require 'vcpkg_pipeline/core/log'

module VPL
  # VPL::Register
  class Register
    def registeries
      path = "#{ENV['HOME']}/.vpl/registries"
      `mkdir -p #{path}` unless File.directory? path
      path
    end

    def list
      Dir["#{registeries}/*"].each do |reg|
        git = Git.open(reg)
        name = File.basename(reg)
        url = git.remote.url
        path = reg

        VPL.info("#{name}")
        puts "- URL:\t#{url}"
        puts "- Path:\t#{path}"
        puts "\n"
      end
    end

    def exist(name)
      is_exist = false
      Dir["#{registeries}/*"].each do |reg|
        is_exist = name.eql? File.basename(reg)
        break if is_exist
      end
      is_exist
    end

    def add(name, url)
      suffix = 0
      while exist(name)
        suffix += 1
        name = "#{name}-#{suffix}"
      end

      Git.clone(url, "#{registeries}/#{name}")
    end

    def remove(name)
      Dir["#{registeries}/*"].each do |reg|
        `rm -fr #{reg}` if name.eql? File.basename(reg)
      end
    end
  end
end
