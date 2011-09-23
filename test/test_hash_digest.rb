# -*- encoding: utf-8 -*-
require 'helper'

describe HashDigest do
  it 'generates a hash of a hash' do
    HashDigest.hexdigest(:a => 1).must_equal '3872c9ae3f427af0be0ead09d07ae2cf'
  end
  
  it 'is indifferent to key type' do
    HashDigest.hexdigest(:a => 1, 'b' => 2).must_equal(HashDigest.hexdigest('a' => 1, :b => 2))
  end
  
  it 'is indifferent to key order' do
    HashDigest.hexdigest(:a => 1, 'b' => 2).must_equal(HashDigest.hexdigest(:b => 2, 'a' => 1))
  end
  
  it 'just as a bonus, works on arrays' do
    HashDigest.hexdigest([:a, 1]).must_equal '8ce19b95077ec34a4fd06b089f368678'
  end
  
  it "raises an exception if you try to digest something it doesn't handle" do
    lambda { HashDigest.hexdigest('foobar') }.must_raise(::ArgumentError)
  end
end
