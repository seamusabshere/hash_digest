# HashDigest

Generates non-cryptographic digests of Hashes (and Arrays) indifferent to key type (string or symbol) and ordering.

Extracted from [`RemoteTable`](https://github.com/seamusabshere/remote_table).

## Note plz

1. You should use `HashDigest.digest2` for new applications. `hexdigest` is legacy.
2. `digest2`, unlike its predecessor, is CASE SENSITIVE.

## Example

### Indifferent to key type

    >> HashDigest.digest2(:a => 1)
    => "1s05qdo"
    >> HashDigest.digest2('a' => 1)
    => "1s05qdo"

### Indifferent to key order

    >> HashDigest.digest2(:a => 1, 'b' => 2)
    => "fkqncr"
    >> HashDigest.digest2(:b => 2, 'a' => 1)
    => "fkqncr"

## Speed

If you're **not** on JRuby, having [`EscapeUtils`](https://github.com/brianmario/escape_utils) in your `Gemfile` will make things much faster.

### With EscapeUtils (MRI, doesn't work on JRuby)

      HashDigest.digest2      2492 i/100ms
    HashDigest.hexdigest      2276 i/100ms
    
### With stdlib's CGI (JRuby)

      HashDigest.digest2       645 i/100ms
    HashDigest.hexdigest       213 i/100ms

### With stdlib's CGI (MRI)

      HashDigest.digest2       531 i/100ms
    HashDigest.hexdigest       513 i/100ms

## Algorithm

### digest2 (current)

1. Represent the hash as a URL querystring
2. Sort by key
3. [MurmurHash3](http://en.wikipedia.org/wiki/MurmurHash)
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
