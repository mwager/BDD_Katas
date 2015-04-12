# Karma configuration

module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: './'

    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['mocha']

    client:
      # should "console.log" calls displayed in the terminal too?
      captureConsole: true

      mocha:
        reporter: 'html'
        ui: 'bdd'

    # list of files / patterns to load in the browser
    files: [
      'node_modules/chai/chai.js'
      'node_modules/sinon/pkg/sinon-1.12.0.js'

      'src/*.coffee' # spec setup, src and specs
    ]

    # list of files to exclude
    exclude: [
    ]

    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      # source files, that you wanna generate coverage for
      # do not include tests or libraries
      # (these files will be instrumented by Istanbul via Ibrik unless
      # specified otherwise in coverageReporter.instrumenter)
      #'src/**/*.coffee': ['coverage'],
      'src/tictactoe.coffee': ['coverage'],
      'src/exercises.coffee': ['coverage'],

      # note: project files will already be converted to
      # JavaScript via coverage preprocessor.
      # Thus, you'll have to limit the CoffeeScript preprocessor
      # to uncovered files.
      'src/spec-setup.coffee' : ['coffee'],
      'src/*.spec.coffee'     : ['coffee']
    }

    # optionally, configure the reporter
    # more reporters: https://github.com/karma-runner/karma-coverage
    coverageReporter: {
      # specify a common output directory
      type : 'html',
      dir : 'coverage/'

    }

    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['mocha', 'coverage']

    # plugins: [
    #   'karma-mocha-reporter'
    # ]

    # web server port
    port: 9876

    # enable / disable colors in the output (reporters and logs)
    colors: true

    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true

    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: [
      # 'Chrome'
      'PhantomJS'
    ]

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false
