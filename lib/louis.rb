require 'json'

require 'louis/const'
require 'louis/helpers'
require 'louis/version'

module Louis
  extend Helpers

  # This masks out both the 'universal/local' bit as well as the
  # 'unicast/multicast' bit which is the first and second least significant bit
  # of the first byte in a vendor prefix.
  IGNORED_BITS_MASK = 0xfcffffffffff

  # Loads the lookup table, parsing out the uncommented non-blank lines into
  # objects we can compare MACs against to find their vendor.
  def self.lookup_table
    @lookup_table ||= JSON.parse(File.read(Louis::PARSED_DATA_FILE))
  end

  # Collect the recorded mask and order it appropriately from most specific to
  # least.
  #
  # @param [Array<Fixnum>]
  def self.mask_keys
    @mask_keys ||= lookup_table.keys.map(&:to_i).sort.reverse
  end

  # Returns the name of the vendor that has the most specific prefix
  # available in the OUI table or failing any matches will return "Unknown".
  #
  # @param [String] mac
  # @return [String]
  def self.lookup(mac)
    encoded_mac = mac_to_num(mac) & IGNORED_BITS_MASK

    lookup_table.each do |mask, table|
      prefix = (encoded_mac & calculate_mask(nil, mask)).to_s
      if table.include?(prefix)
        vendor = table[prefix]
        return {'long_vendor' => vendor['l'], 'short_vendor' => vendor['s']}
      end
    end
    
    {'long_vendor' => 'Unknown', 'short_vendor' => 'Unknown'}
  end
end
