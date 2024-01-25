LINE_ITEM_REGEX = /^([0-9]+) (.*) at ([0-9\.]*)/

BASIC_SALES_TAX_RATE = 0.1
IMPORT_DUTY_RATE     = 0.05
ROUNDING_FACTOR      = 0.05 

BASIC_SALES_TAX_EXEMPTIONS = ['books', 'food', 'medical']

CATEGORY_MAPPING = {
  'book': 'books',
  'chocolate': 'food',
  'pills': 'medical'
}