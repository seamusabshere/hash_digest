require 'bundler/setup'
require 'minitest/autorun'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hash_digest'

require 'benchmark/ips'
require 'active_support/core_ext'

module TestHelper
  def as_digest1(hsh)
    ordered_list = if hsh.is_a?(::Hash)
      hsh = hsh.stringify_keys
      hsh.keys.sort.map { |k| hsh[k].to_query k }
    elsif hsh.is_a?(::Array)
      ary = []
      hsh.each_with_index { |v, i| ary.push v.to_query(i.to_s) }
      ary
    else
      raise ::ArgumentError, "[hash_digest gem] Can only digest Hashes and Arrays, not #{hsh.class}"
    end
    ordered_list.join('&')
  end

  def assert_same_as_old(a)
    expected = as_digest1(a)
    got = HashDigest.as_digest1(a)
    got.must_equal expected
  end
end
