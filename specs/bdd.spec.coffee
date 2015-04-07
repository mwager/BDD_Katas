# Spec exercises from the book

describe "BDD Katas", ->

  ###
  * Define factories here
  ###
  window.SeminarFactory =
    create: (name = "JavScript-Basics", price = 100, isTaxFree = false) ->
      return new Seminar(name, price, isTaxFree)

  window.ProductFactory =
    create: (name = "Some product", price = 100) ->
      return new Product(name, price)
  window.StudyBookFactory =
    create: (name = "Git Basics", price = 100) ->
      return new StudyBook(name, price)

  window.CartFactory =
    create: () ->
      return new Cart()



  ###
  * First part of the book: Seminar specs
  ###
  describe "Seminar", ->
    beforeEach ->
      @sem = SeminarFactory.create()

    it "should have a name", ->
      expect(@sem.getName()).to.equal 'JavScript-Basics'

    it "should have a price", ->
      expect(@sem.getPrice()).to.equal 100

    it 'should have a gross_price that adds 20% VAT to the net price', ->
      expect(@sem.getGrossPrice()).to.equal 120

    xit "should save the queen (example of pending spec)", ->
      log "the queen is saved"

    describe 'A tax-free Seminar', ->
      beforeEach ->
        @sem = SeminarFactory.create null, null, true

      it 'should return true on #isTaxFree() if intialized as taxFree', ->
        expect(@sem.isTaxFree()).to.equal true
        # CUSTOM ASSERTIONS: see setup.coffee
        expect(@sem).to.be.taxFree

      it 'should have a gross_price that matches net price if it is tax free', ->
        expect(@sem.getGrossPrice()).to.equal @sem.getPrice()

    describe 'A 3-letter Seminar that is priced 200$', ->
      beforeEach ->
        @sem = SeminarFactory.create "BDD", 200

      it 'should have a 3letter-discount granted', ->
        expect(@sem).to.be.hasThreeLetterDiscountGranted

      it 'should give a discount of 5%', ->
        expect(@sem.discountPercentage()).to.equal 5

      it 'should have a discount of 10$', ->
        expect(@sem.discount()).to.equal 10

      it 'should have a net price of 190$', ->
        expect(@sem.getPrice()).to.equal 190

    describe 'A more than 3-letter Seminar that is priced 200$', ->
      beforeEach ->
        @sem = SeminarFactory.create "Learning PHP the wrong way", 200

      it 'should have a NO 3letter-discount granted', ->
        expect(@sem).to.not.be.hasThreeLetterDiscountGranted

      it 'should give a discount of 0%', ->
        expect(@sem.discountPercentage()).to.equal 0

      it 'should have a discount of 0$', ->
        expect(@sem.discount()).to.equal 0

      it 'should have a net price of 200$', ->
        expect(@sem.getPrice()).to.equal 200

  ###
  * Second part of the book: LOW LEVEL SPECS
  *   -> Product & StudyBook low level specs
  *   -> Cart low level specs
  *
  *   - They help to find specific bugs (defect localization). -> find bugs
  *   - They are most useful to developers that maintain the code later.
  *   - There are usually a lot of low level specs since they need to
  *     cover all the low level details, special and edge cases.
  ###
  describe "A Product", ->
    beforeEach ->
      @product = ProductFactory.create(null, 100)

    it "should calculate its #grossPrice by adding a VAT of 20%", ->
      expect(@product.grossPrice()).to.equal 120

  describe "A StudyBook", ->
    beforeEach ->
      @studyBook = StudyBookFactory.create null, 100

    it "should calculate its #grossPrice by adding a VAT of 7%", ->
      expect(@studyBook.grossPrice()).to.equal 107

  describe "Cart", ->
    beforeEach ->
      @cart = CartFactory.create()

    describe "A new cart", ->
      it "should contain no products", ->
        expect(@cart.numProducts()).to.equal 0

    describe "#add", ->
      it "should add a product to the cart", ->
        product = {}
        @cart.add(product)
        expect(@cart.doesContain(product)).to.equal true
        expect(@cart.numProducts()).to.equal 1

      it "should deduct the product from stock (MOCKING!)", ->
        spy     = sinon.spy(Stock, "removeProduct")
        product = ProductFactory.create("TheProduct", 100)

        @cart.add(product)

        expect(spy.withArgs(product.name).calledOnce).to.equal true

    describe "#doesContain", ->
      it "should return false for a product that is not contained", ->
        anotherProduct = {}
        expect(@cart.doesContain(anotherProduct)).to.equal false

    describe "#grossPriceSum", ->
      it "should be 0 for an empty cart", ->
        expect(@cart.grossPriceSum()).to.equal 0

      it "should return the grossPrice of a single product in the cart", ->
        # STUB
        # "A stub uses fake values to replace an implementation."
        # Possibility #1 - own stub
        # product = {grossPrice: -> return 10}
        # Possibility #2 - sinon spies/stubs !?
        product = {grossPrice: -> }
        sinon.stub(product, "grossPrice").returns 10 # we want to fake the return value of grossPrice()
        @cart.add(product)
        expect(@cart.grossPriceSum()).to.equal 10

      it "should return the sum of 2 products in the cart", ->
        product1 = {grossPrice: -> return 10}
        product2 = {grossPrice: -> return 15}
        @cart.add(product1)
        @cart.add(product2)
        expect(@cart.grossPriceSum()).to.equal 25

  ###
  * High level specs
  *
  * Testing whole scenarios here
  *
  * - They help you to become aware of bugs – all spec violations are considered
  *   as a bug (defect awareness). -> SHOW BUGS
  * - They are most useful when shown to stakeholders.
  * - There are usually only a few. They don't include all special cases and details.
  *   Their main purpose is to provide an overview of the required functionality
  ###
  describe "--- HIGH LEVEL SPECS ---", ->
    describe "A cart with several different products", ->
      beforeEach ->
        @cart = CartFactory.create()

      it 'should have a #grossPriceSum of the contained products', ->
        licence   = ProductFactory.create "UltraIDE Licence", 100
        studyBook = StudyBookFactory.create "Secrets of HTML", 10

        @cart.add licence
        @cart.add studyBook

        expect(@cart.grossPriceSum()).to.equal 100 * 1.20 + 10 * 1.07












  describe "String.prototype.calc", ->

    it "should return 0 if the string is empty", ->
      expect("".calc()).to.equal 0

    it "should return a number from the string", ->
      expect("3".calc()).to.equal 3

    it "should return the sum of three comma separated numbers", ->
      expect("1,2,3".calc()).to.equal 6
      expect("1,2,3,4,3".calc()).to.equal 13

    it "should work with line breaks", ->
      expect("1\n2,3".calc()).to.equal 6

    it "should work with other non comma seperators introduced by start line \"//\"", ->
      expect("//;1\n1;2".calc()).to.equal 3
