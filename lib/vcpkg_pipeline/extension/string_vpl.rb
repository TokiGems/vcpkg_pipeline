# frozen_string_literal: true

# String
class String
  def clean
    gsub(/\#.*/, '').gsub(/\(/, ' ( ').gsub(/\)/, ' ) ').gsub(/\n/, ' ').gsub(/\ +/, ' ')
  end
end
