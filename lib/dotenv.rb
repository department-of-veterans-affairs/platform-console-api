# frozen_string_literal: true

# Loads .env file automatically in development and test
class Dotenv
  def load(files)
    files.each { |file| load_file file }
  end

  private

  def load_file(file)
    return unless File.exist? file

    File.readlines(file).each do |line|
      next if comment? line

      key, value = key_values_from_line line
      next unless key && value

      ENV[key] ||= value
    end
  end

  def key_values_from_line(line)
    key, value = line.chomp.split '=', 2
    return unless value

    value = trim_quotes value
    value = replace_newline_character value
    [key, value]
  end

  def comment?(string)
    string.start_with? '#'
  end

  def trim_quotes(string)
    string = string[0..] if string.start_with? "'", '"'
    string = string[1...-1] if string.end_with? "'", '"'
    string
  end

  def replace_newline_character(string)
    string.gsub '\n', "\n"
  end
end

case ENV['RAILS_ENV']
when 'development'
  Dotenv.new.load %w[.env .env.local]
when 'test'
  Dotenv.new.load %w[.env.test]
end
