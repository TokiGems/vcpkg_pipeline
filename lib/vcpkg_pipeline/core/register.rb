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
      Dir["#{registeries}/*"].each do |registory|
        git = Git.open(registory)
        name = File.basename(registory)
        url = git.remote.url
        path = registory

        VPL.info("\
        \n#{name}\
        \n- URL:\t#{url}\
        \n- Path:\t#{path}")
      end
    end

    def exist(name)
      is_exist = false
      Dir["#{registeries}/*"].each do |registory|
        is_exist = name.eql? File.basename(registory)
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
      Dir["#{registeries}/*"].each do |registory|
        `rm -fr #{registory}` if name.eql? File.basename(registory)
      end
    end
  end
end
