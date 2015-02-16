require 'json'

require 'louis/const'
require 'louis/helpers'
require 'louis/version'

module Louis
  extend Helpers

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
    match = nil

    mask_keys.each do |mask|
      prefix = mac_to_num(mac) & calculate_mask(nil, mask)
      match = lookup_table[mask.to_s][prefix.to_s]

      break if match
    end

    if match
      {'long_vendor' => match['l'], 'short_vendor' => match['s']}
    else
      {'long_vendor' => 'Unknown', 'short_vendor' => 'Unknown'}
    end
  end
end
