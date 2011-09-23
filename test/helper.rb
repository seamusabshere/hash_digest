require 'bundler/setup'
require 'minitest/spec'
require 'minitest/autorun'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hash_digest'

class MiniTest::Unit::TestCase
end
