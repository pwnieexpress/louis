require 'louis/const'
require 'louis/helpers'
require 'louis/version'

module Louis
  extend Helpers

  # Search through the OUI lookup table and return all the entries in the
  # lookup table that match the provided MAC.
  #
  # @param [String] mac
  # @return [Array<Hash<String=>Object>>]
  def self.find_matches(mac)
    @lookup_table.select { |m| mac_matches_prefix?(mac, m['prefix'], m['mask']) }
  end

  # Loads the lookup table, parsing out the uncommented non-blank lines into
  # objects we can compare MACs against to find their vendor.
  def self.load_lookup_table
    @lookup_table ||= []
    return unless @lookup_table.empty?

    File.open(ORIGINAL_OUI_FILE).each_line do |line|
      res = line_parser(line)
      @lookup_table.push(res) if res
    end
  end

  # Returns the name of the vendor that has the most specific prefix
  # available in the OUI table or failing any matches will return "Unknown".
  #
  # @param [String] mac
  # @return [String]
  def self.lookup(mac)
    load_lookup_table

    o = find_matches(mac).sort_by { |m| m['prefix'] }.first
    o ||= {'long_vendor' => 'Unknown', 'short_vendor' => 'Unknown'}

    o.select { |k,_| %w(long_vendor short_vendor).include?(k) }
  end

  # Checks to see whether or not the MAC address has the provided prefix.
  #
  # @param [String] mac
  # @param [Fixnum] prefix
  # @param [Fixnum] mask
  # @return [Boolean]
  def self.mac_matches_prefix?(mac, prefix, mask)
    (mac_to_num(mac) & mask) == prefix
  end
end
