# global log helpers
window.log = ->
  console?.log(arguments...)
window.err = ->
  console?.error(arguments...)

###
* Extend chai assertions with own matchers/methods
###
extendAssertions = (_chai, utils) ->
  utils.addProperty chai.Assertion.prototype, 'taxFree', ->
    name = this._obj

    this.assert(
      this._obj.isTaxFree(),
      "expected seminar '#{name}' to be tax free",
      "expected seminar '#{name}' to not be tax free"
    )

  utils.addProperty chai.Assertion.prototype, 'hasThreeLetterDiscountGranted', ->
    name = this._obj

    this.assert(
      this._obj.hasThreeLetterDiscountGranted(),
      "expected seminar '#{name}' to have 3 letter discount granted but got " +
        this._obj.hasThreeLetterDiscountGranted(),
      "expected seminar '#{name}' to not have 3 letter discount granted but got " +
        this._obj.hasThreeLetterDiscountGranted()
    )


chai.use(extendAssertions)


# mocha.setup('bdd')
window.expect = chai.expect
