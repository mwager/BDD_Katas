window.Seminar = class
  _VAT_RATE = 1.20
  _DISCOUNT_PERC = 5

  _name = '' # init privates like so
  _price = 0
  _isTaxFree = false
  _isThreeLetterSeminar = false

  constructor: (name, price, isTaxFree) ->
    _name = name
    _price = price
    _isTaxFree = isTaxFree
    _isThreeLetterSeminar = _name.length is 3

  getName: ->
    return _name

  getPrice: ->
    return _price - this.discount()

  getGrossPrice: ->
    return if _isTaxFree is true then _price else _price * 1.20

  isTaxFree: ->
    return _isTaxFree

  hasThreeLetterDiscountGranted: ->
    return _isThreeLetterSeminar

  discountPercentage: ->
    return if _isThreeLetterSeminar is true then _DISCOUNT_PERC else 0

  discount: ->
    if _isThreeLetterSeminar is true
      return _DISCOUNT_PERC / 100 * _price
    else
      return 0

  toString: ->
    return "[Seminar #{_name}]"


window.Product = class
  constructor: (name, price) ->
    @_VAT_RATE = 1.20
    @name      = name
    @price     = price

  grossPrice: ->
    return @price * @_VAT_RATE


window.StudyBook = class extends Product
  constructor: (name, price) ->
    super(name, price) # first call super...

    @_VAT_RATE = 1.07  # ...then overwrite the vat rate!


# placeholder for missing Stock impl
window.Stock = {
  removeProduct: ->
}

window.Cart = class
  constructor: ->
    @_products = []

  numProducts: ->
    return @_products.length

  doesContain: (product) ->
    # return @_products.indexOf(product) >= 0
    return product in @_products

  add: (product) ->
    Stock.removeProduct(product.name)
    @_products.push(product)

  grossPriceSum: ->
    # IMPL #1 - using map and reduce with coffeescript [:-(]
    # reduceCallback = (sum, p) ->
    #     return sum + p
    # return @_products
    #   .map (p) ->
    #     return p.grossPrice()
    #   .reduce reduceCallback, 0

    # IMPL #2 - simple for loop
    # sum = 0
    # for p in @_products
    #   sum += p.grossPrice()
    # return sum

    # IMPL #2 - foreach
    sum = 0
    @_products.forEach (p) ->
      sum += p.grossPrice()
    return sum




# kata try #2 - map, reduce, filter
String::calc = ->
  str = this
  delimiter = ','

  if str.length is 0
    return 0

  # does the string start with "//"
  if str[0] is '/' and str[1] is '/'
    delimiter = str[2]
    str = str.replace(/\n/, ',')

  # line breaks - convert to commas
  if(/\n/.test(str))
    str = str.replace /\n/, delimiter


  # comma seperated
  if str.match delimiter
    arr = str.split delimiter
    sum = 0

    arr.map (el, idx, origArr) ->
    #arr.filter (el, idx, origArr) -> SAME!
      val = parseInt el, 10
      if !isNaN val
        sum += val

    # for el in arr
    #   val = parseInt el, 10

    #   if !isNaN val
    #     sum += val

    return sum

# kata try #1
# String::calc = ->
#   str = this
#   delimiter = ','

#   if str.length is 0
#     return 0;

#   # does the string start with "//"
#   if str[0] is '/' and str[1] is '/'
#     delimiter = str[2]
#     str = str.replace(/\n/, ',')

#   # line breaks - convert to commas
#   if(/\n/.test(str))
#     str = str.replace /\n/, delimiter


#   # comma seperated
#   if str.match delimiter
#     arr = str.split delimiter
#     sum = 0

#     for el in arr
#       val = parseInt el, 10

#       if !isNaN val
#         sum += val

#     return sum;


  # number from string
  val = parseInt str, 10
  if typeof val is 'number'
    return val
