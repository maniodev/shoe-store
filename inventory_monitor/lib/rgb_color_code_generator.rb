# frozen_string_literal: true

class RgbColorCodeGenerator
  def self.generate(name, opacity)
    digest = Digest::MD5.digest(name)
    values = digest.unpack("SSS")
    codes = values.map { |i| i * 201 / 0x10000 }

    "rgba(#{codes[0]}, #{codes[1]}, #{codes[2]}, #{opacity})"
  end
end
