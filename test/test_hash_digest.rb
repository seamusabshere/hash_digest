# -*- encoding: utf-8 -*-
require 'helper'
require 'stringio'

describe HashDigest do
  include TestHelper

  describe '.digest2' do
    it "is much faster than .hexdigest" do
      hsh = { 'a' => 1, :b => { foo: :bar, zoo: 'animal' }, ";b\n`&" => { foo: :bar, zoo: "==&ani!!.;&mal\n" } }
      begin
        old_stdout = $stdout
        $stdout = StringIO.new
        Benchmark.ips do |x|
          x.report("HashDigest.hexdigest")  { HashDigest.hexdigest(hsh) }
          x.report("HashDigest.digest2")    { HashDigest.digest2(hsh)   }
        end
        $stdout.rewind
        result = $stdout.read
      ensure
        $stdout = old_stdout
      end
      result.must_equal ''
    end
  end

  describe 'backwards compatibility' do
    it 'for hashes' do
      HashDigest.hexdigest(:a => 1).must_equal '3872c9ae3f427af0be0ead09d07ae2cf'
    end
    
    it 'for arrays' do
      HashDigest.hexdigest([:a, 1]).must_equal '8ce19b95077ec34a4fd06b089f368678'
    end

    [
      { :a => 1 },
      { 'b' => 99.9 },
      { 'b`&' => 99.9 },
      { ';b`&' => '99.9!!.;&' },
      { ";b\n`&" => "99.9!\n!.;&" },
      { :b => { foo: :bar, zoo: 'animal' } },
      { :b => { foo: :bar, zoo: '==&ani!!.;&mal' } },
      { :b => { foo: :bar, zoo: "==&ani!!.;&mal\n" } },
      { :a => 1, 'b' => 2 },
      { 'a' => 1, :b => 2 },
      { 'a' => 1, :b => [1, 2] },
      { 'a' => 1, :b => { foo: :bar, zoo: 'animal' } },
    ].each do |hsh|
      it "treats #{hsh} same as old" do
        assert_same_as_old hsh
      end
    end

  end

  describe 'indifference to' do
    it 'key type' do
      HashDigest.as_digest2(:a => 1, 'b' => 2).must_equal(HashDigest.as_digest2('a' => 1, :b => 2))
    end
    
    it 'key order' do
      HashDigest.as_digest2(:a => 1, 'b' => 2).must_equal(HashDigest.as_digest2(:b => 2, 'a' => 1))
    end

    [
      [{:a => 1, 'b' => 2},             {'a' => 1, :b => 2}],
      [{:a => 1, 'b' => [1, 2]},        {'a' => 1, :b => ['1', 2]}],
      [{:a => 1, 'b' => { foo: :bar }}, {'a' => 1, :b => { 'foo' => 'bar' }}],
    ].each do |a, b|
      it "trivial difference between #{a} and #{b}" do
        assert_same_as_old a
        assert_same_as_old b
        HashDigest.as_digest2(b).must_equal(HashDigest.as_digest2(b))
      end
    end
  end
  
  it "raises an exception if you try to digest anything other than a Hash or Array" do
    lambda { HashDigest.hexdigest('foobar') }.must_raise(::ArgumentError)
  end
end
