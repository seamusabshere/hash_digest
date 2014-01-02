require 'digest/md5'
require 'murmurhash3'
# see below for requiring either cgi (on JRuby) or escape_utils (if available)

require "hash_digest/version"

module HashDigest
  # CURRENT

  def self.as_digest2(obj)
    obj.to_hash_digest_query
  end

  def self.digest2(obj)
    ::MurmurHash3::V32.str_hash(as_digest2(obj)).to_s 36
  end

  # LEGACY

  def self.as_digest1(obj)
    ordered_list = case obj
    when ::Hash
      obj.map do |k, v|
        obj[k].to_hash_digest_query k
      end.sort
    when ::Array
      ary = []
      obj.each_with_index do |v, i|
        ary << v.to_hash_digest_query(i)
      end
      ary
    else
      raise ::ArgumentError, "[hash_digest gem] Can only digest Hashes and Arrays, not #{obj.class}"
    end
    ordered_list.join '&'
  end

  def self.hexdigest(obj)
    ::Digest::MD5.hexdigest as_digest1(obj)
  end

  # CGI escaping engine

  if RUBY_PLATFORM == 'java'
    require 'cgi'
    def self.escape_url(str);     ::CGI.escape(str) end
  else
    begin
      # MUCH faster than stdlib's cgi
      require 'escape_utils'
      def self.escape_url(str);   ::EscapeUtils.escape_url(str) end
    rescue LoadError
      require 'cgi'
      def self.escape_url(str);   ::CGI.escape(str) end
    end
  end
end

# EVERYTHING BELOW IS COPIED FROM ACTIVESUPPORT 4.0.2

class Object
  def to_hash_digest_param
    to_s
  end
end

class Array
  def to_hash_digest_param
    map { |e| e.to_hash_digest_param }.join '/'
  end

  def to_hash_digest_query(key)
    prefix = "#{key}[]"
    map { |value| value.to_hash_digest_query(prefix) }.join '&'
  end
end

class Hash
  def to_hash_digest_param(namespace = nil)
    map do |key, value|
      value.to_hash_digest_query(namespace ? "#{namespace}[#{key}]" : key)
    end.sort.join '&'
  end
  alias_method :to_hash_digest_query, :to_hash_digest_param
end

class Object
  def to_hash_digest_query(key)
    "#{::HashDigest.escape_url(key.to_hash_digest_param)}=#{::HashDigest.escape_url(to_hash_digest_param)}"
  end
end
