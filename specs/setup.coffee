# global log helpers
window.log = ->
  console?.log(arguments...)
window.err = ->
  console?.error(arguments...)

# mocha.setup('bdd')
window.expect = chai.expect
