# Basic sales tax is applicable at a rate of 10% on all goods, except books, food, and medical products that are exempt. 
# Import duty is an additional sales tax applicable on all imported goods at a rate of 5%, with no exemptions.
require_relative './constants'
require_relative './receipt_item'

class ReceiptGenerator 
  def initialize(items)
    @raw_items = items
  end

  def call
    parse_items
    calculate_sum_amounts
    build_receipt
  end

  private 

  attr_reader :items, :sales_taxes, :total_amount

  def parse_items
    @items = @raw_items.split("\n").map do |line_item|
      match_data = line_item.match(LINE_ITEM_REGEX) 
      if match_data
        ReceiptItem.new(*match_data.captures) 
      else
        raise ArgumentError, "Invalid line item"
      end
    end
    @items = @items.compact
  end

  def calculate_sum_amounts
    @sales_taxes = @items.sum(&:sales_taxes_in_cents) / 100.0
    @total_amount = @items.sum(&:total_amount_in_cents) / 100.0
  end

  def build_receipt
    receipt = ""
    @items.each do |item|
      receipt << "#{item.quantity} #{item.description}: %.2f\n" % item.total_amount
    end
    receipt << "Sales Taxes: %.2f\n" % sales_taxes
    receipt << "Total: %.2f" % total_amount
    receipt
  end
end