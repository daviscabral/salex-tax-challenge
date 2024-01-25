#!/usr/bin/env ruby

require_relative '../lib/receipt_generator'

if $0 == __FILE__
  raise ArgumentError, "Usage: #{$0} '[quantity] [description] at [amount]'" unless ARGV.length > 0
  result = ReceiptGenerator.new(ARGV.join("\n")).call
  puts result
end