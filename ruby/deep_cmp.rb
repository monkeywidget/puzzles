require 'fileutils'

class DeepCompare
  def initialize
    super
    @differences = []
  end

  def usage
    puts "USAGE deep_cmp a_dir b_dir\n\twhere a_dir and b_dir are directories"
    puts "\t∃ path exists"
    puts "\t¬∃ path does not exist"
    puts "\t> path is larger than"
    puts "\t!= path is the same size but different than"
    exit 1
  end

  def deep_cmp(a_dir, b_dir)
    usage if a_dir.nil? || b_dir.nil?
    usage unless File.directory?(a_dir) && File.directory?(b_dir)

    cmp(a_dir, b_dir)

    puts @differences.join("\n")
  end

  def loop_dir(a_path,b_path)
    all_children = (Dir.children(a_path) + Dir.children(b_path)).sort.uniq

    all_children.each do |child_path|
      cmp("#{a_path}/#{child_path}", "#{b_path}/#{child_path}")
    end
  end

  # compares files only
  def file_cmp(a_path,b_path)
    return if File.identical?(a_path,b_path)

    if File.size(a_path) > File.size(b_path)
      @differences << "#{a_path} > #{b_path}"
    elsif File.size(b_path) > File.size(a_path)
      @differences << "#{a_path} < #{b_path}"
    else
      @differences << "#{a_path} != #{b_path}" unless FileUtils.compare_file(a_path, b_path)
    end
  end

  # compares path (directories and files) and calls the appropriate subroutine
  def cmp(a_path, b_path)
    if File.exist?(a_path)
      unless File.exist?(b_path)
        @differences << "#{a_path} ∃,¬∃ #{b_path}"
        return
      end
    else
      if File.exist?(b_path)
        @differences << "#{a_path} ¬∃,∃ #{b_path}"
        return
      end
    end

    if File.directory?(a_path)
      if File.directory?(b_path)
        loop_dir(a_path,b_path)
      else
        @differences << "#{a_path} is a directory but #{b_path} is not"
        return
      end
    else
      if File.directory?(b_path)
        @differences << "#{b_path} is a directory but #{a_path} is not"
        return
      else
        file_cmp(a_path,b_path)
      end
    end
  end
end

DeepCompare.new.deep_cmp(ARGV[0],ARGV[1])
