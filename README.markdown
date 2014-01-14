# HashDigest

Generates non-cryptographic digests of Hashes (and Arrays) indifferent to key type (string or symbol) and ordering.

Extracted from [`RemoteTable`](https://github.com/seamusabshere/remote_table).

## Note plz

1. You should use `HashDigest.digest3` for new applications. `hexdigest` and `digest2` are legacy.
2. `digest2` is CASE SENSITIVE and has relatively high level of collisions - not recommended.

## Example

### Indifferent to key type

    >> HashDigest.digest3(:a => 1)
    => "86eda770a6060824b090dd4df091e3bd4121279c"
    >> HashDigest.digest3('a' => 1)
    => "86eda770a6060824b090dd4df091e3bd4121279c"

### Indifferent to key order

    >> HashDigest.digest3(:a => 1, 'b' => 2)
    => "d53cf64e768f4ef09c806bbe12258c78211b2690"
    >> HashDigest.digest3(:b => 2, 'a' => 1)
    => "d53cf64e768f4ef09c806bbe12258c78211b2690"

## Speed

If you're **not** on JRuby, having [`EscapeUtils`](https://github.com/brianmario/escape_utils) in your `Gemfile` will make things much faster.

## Algorithm

### digest3

1. Represent the hash as a URL querystring
2. Sort by key
3. SHA1 hexdigest

### digest2 (deprecated and not recommended)

1. Represent the hash as a URL querystring
2. Sort by key
3. [MurmurHash3](http://en.wikipedia.org/wiki/MurmurHash) V32 (this turned out to have too many collisions)
4. Convert to base 36 to save space

Note: non-cryptographic and variable length. CASE SENSITIVE.

### hexdigest (deprecated)

Basically represent the hash as a URL querystring, ordered by key, and MD5 that.

1. Stringify keys
2. Create an array of strings like "url_encode(key)=url_encode(value)" by going through each key in alphabetical order
3. Join the array together with "&"
4. MD5 hexdigest the joined string

To digest an array, just pretend it's a hash with keys like 1, 2, 3, etc.

## Potential issues

* Meant for flat hashes, e.g. { :a => 1, :b => 2 } and not { :x => { :y => :z } }

## Copyright

Copyright 2013 Seamus Abshere
