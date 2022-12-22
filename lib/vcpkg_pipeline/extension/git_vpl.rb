# frozen_string_literal: true

require 'git'

require 'vcpkg_pipeline/core/log'

module Git
  # Git::Base
  class Base
    def current_branch
      branches.current.first
    end

    def quick_push_tag(has_tag)
      push(remote, current_branch, has_tag)
      VPL.info("Git上传 #{remote} #{current_branch} #{new_version}")
    end

    def quick_push(new_tag = nil)
      return if ENV['Debug']

      has_tag = !new_tag.empty?
      if has_tag
        tags.each { |tag| VPL.error("当前版本 #{new_tag} 已发布, 请尝试其他版本号") if tag.name.eql? new_tag }

        add_tag(new_tag)
        VPL.info("Git提交Tag: #{new_tag}")
      end
      quick_push_tag(has_tag)
    end

    def to_s
      "#{remote}-#{branches.current.first}"
    end
  end

  # Git::Branches
  class Branches
    def current
      local.select { :current }
    end
  end
end
