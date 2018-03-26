require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'minitest/autorun'
require 'mocha/mini_test'

require 'dd-next-encounters'

