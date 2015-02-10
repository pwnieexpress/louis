require 'louis/const'
require 'louis/version'

module Louis
  # Calculate the bit mask for testing whether or not a mac_prefix matches.
  # This returns an integer with the upper X bits set where X is the mask
  # length.
  #
  # @param [String] prefix
  # @param [String] mask
  # @return [Fixnum]
  def self.calculate_mask(prefix, mask)
    mask_base = mask.nil? ? (clean_mac(prefix).length * 4) : mask.to_i
    (2 ** 48 - 1) - (2 ** (48 - mask_base) - 1)
  end

  # Returns the hex representing a full or partial MAC address with the
  # 'connecting' characters removed. Does nothing to ensure length.
  #
  # @param [String] mac
  # @return [String]
  def self.clean_mac(mac)
    mac.gsub(/[:-]/, '')
  end

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
      if (matches = OUI_FORMAT_REGEX.match(line))
        result = Hash[matches.names.zip(matches.captures)]

        @lookup_table.push({
          'mask'         => calculate_mask(result['prefix'], result['mask']),
          'prefix'       => mac_to_num(result['prefix']),
          'short_vendor' => result['short_vendor'],
          'long_vendor'  => result['long_vendor']
        })
      end
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

  # Converts a hexidecimal version of a full or partial (prefix) MAC address
  # into it's integer representation.
  #
  # @param [String] mac
  def self.mac_to_num(mac)
    clean_mac(mac).ljust(12, '0').to_i(16)
  end
end
