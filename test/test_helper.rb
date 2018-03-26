require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'monsters_manual'
require 'lair'
require 'monster'

require 'minitest/autorun'
require 'mocha/mini_test'

