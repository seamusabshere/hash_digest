# HashHash

Generates MD5 digests of Hashes (and Arrays) indifferent to key type and ordering.

Useful for hashing rows in a 2-dimensional table.

Used by the [remote_table](https://github.com/seamusabshere/remote_table) gem.

## Example

### Indifferent to key type

    HashDigest.hexdigest(:a => 1)  #=> '3872c9ae3f427af0be0ead09d07ae2cf'
    HashDigest.hexdigest('a' => 1) #=> '3872c9ae3f427af0be0ead09d07ae2cf'

### Indifferent to key order

    HashDigest.hexdigest(:a => 1, 'b' => 2) == HashDigest.hexdigest('a' => 1, :b => 2) # true
    HashDigest.hexdigest(:a => 1, 'b' => 2) == HashDigest.hexdigest(:b => 2, 'a' => 1) # true

## Algorithm

Basically represent the hash as a URL querystring, ordered by key, and MD5 that.

1. Stringify keys
2. Create an array of strings like "url_encode(key)=url_encode(value)" by going through each key in alphabetical order
3. Join the array together with "&"
4. MD5 hexdigest the joined string

To digest an array, just pretend it's a hash with keys like 1, 2, 3, etc.

## Potential issues

* Uses MD5 (not cryptographically awesome)
* Uses ActiveSupport's <tt>#to_query</tt> method to create a digestible string like "foo=bar&baz=bam" (slow)
* Meant for flat hashes, e.g. { :a => 1, :b => 2 } and not { :x => { :y => :z } }

## Copyright

Copyright 2011 Seamus Abshere
