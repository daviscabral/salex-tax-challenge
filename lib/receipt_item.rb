require_relative './constants'

class ReceiptItem
  attr_reader :quantity, :description, :amount_in_cents, :category, :imported, :exempt

  def initialize(quantity, description, amount_in_cents, category = nil)
    @quantity = quantity.to_i
    @description = description
    @category = category || self.identify_category_from_description(description)
    @imported = description.include?("imported")
    @exempt = BASIC_SALES_TAX_EXEMPTIONS.include?(@category)
    @amount_in_cents = (amount_in_cents.to_f * 100).to_i

    raise ArgumentError, "Invalid quantity" if @quantity <= 0
    raise ArgumentError, "Invalid amount" if @amount_in_cents <= 0
  end

  def total_amount_in_cents
    @total_amount_in_cents ||= begin
      (amount_in_cents * quantity + sales_taxes_in_cents)
    end
  end

  def round_amount_in_cents(amount_in_cents)
    rounding_coefficient = 1 / ROUNDING_FACTOR
    ((rounding_coefficient * amount_in_cents) / 100.0).ceil / rounding_coefficient * 100 
  end

  def sales_taxes_in_cents
    @sales_taxes ||= begin
      round_amount_in_cents(basic_sales_tax + import_duty)
    end
  end

  def total_amount
    total_amount_in_cents / 100.0
  end

  private

  def import_duty
    return amount_in_cents * quantity * IMPORT_DUTY_RATE if imported
    0
  end

  def basic_sales_tax
    return amount_in_cents * quantity * BASIC_SALES_TAX_RATE unless exempt
    0
  end

  def identify_category_from_description(description)
    category = "unknown"
    CATEGORY_MAPPING.each do |key, value|
      category = value if description.include?(key.to_s)
    end
    category
  end
end