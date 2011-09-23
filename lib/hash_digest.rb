require 'digest/md5'
require 'active_support'
require 'active_support/version'
%w{
  active_support/core_ext/hash/keys
  active_support/core_ext/object/to_query
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ::ActiveSupport::VERSION::MAJOR >= 3

require "hash_digest/version"

module HashDigest
  def self.hexdigest(hsh)
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
    ::Digest::MD5.hexdigest ordered_list.join('&')
  end
end
