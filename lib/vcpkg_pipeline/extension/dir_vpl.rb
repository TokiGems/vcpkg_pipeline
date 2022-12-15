# frozen_string_literal: true

# Dir
class Dir
  def reset(path)
    return unless File.directory? path

    `rm -fr #{path}`
    `mkdir #{path}`
  end

  def self.replace_content(path, replacements)
    content = File.read(path)
    replacements.each do |find, replace|
      content = content.gsub(find, replace)
    end
    File.write(path, content)
  end

  def self.replace_all(path, replacements)
    Dir["#{path}/*"].each do |subpath|
      subpath_rpl = subpath
      replacements.each { |find, replace| subpath_rpl = subpath_rpl.gsub(find, replace)}
      File.rename(subpath, subpath_rpl)

      if File.directory? subpath_rpl
        replace_all(subpath_rpl, replacements)
      else
        replace_content(subpath_rpl, replacements)
      end
    end
  end
end
