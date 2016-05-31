require 'spec_helper'

RSpec.describe Louis do
  it 'has a version number' do
    expect(Louis::VERSION).not_to be nil
  end

  it "it should have its source data file" do
    expect(File.readable?(Louis::ORIGINAL_OUI_FILE)).to be(true)
  end

  it "it should have its parsed data file" do
    expect(File.readable?(Louis::PARSED_DATA_FILE)).to be(true)
  end

  describe 'Original OUI format regex' do
    subject { Louis::OUI_FORMAT_REGEX }

    it "should ignore comment lines" do
      comment_line = "# This is just a sample of what a comment might look like"
      expect(subject).to_not match(comment_line)
    end

    it "should ignore blank lines" do
      expect(subject).to_not match("")
    end
  end

  # The core of the whole library
  describe '#lookup' do
    let(:base_mac) { '00:12:34:00:00:00' }
    let(:partial_mac) { '3c:97:0e' }
    let(:unknown_mac) { 'c5:00:00:00:00:00' }
    let(:local_mac)     { '3e:97:0e' }
    let(:multicast_mac) { '3d:97:0e' }

    it 'should return a hash' do
      expect(Louis.lookup(base_mac)).to be_a(Hash)
    end

    it 'should have both the long vendor and short vendor' do
      expect(Louis.lookup(base_mac).keys).to eq(['long_vendor', 'short_vendor'])
    end

    it 'should be able to identify the short vendor of a full MAC' do
      expect(Louis.lookup(base_mac)['short_vendor']).to eq('CamilleB')
    end

    it 'should be able to identify the long vendor of a full MAC' do
      expect(Louis.lookup(base_mac)['long_vendor']).to eq('Camille Bauer')
    end

    it 'should be able to identify the short vendor of a partial MAC' do
      expect(Louis.lookup(partial_mac)['short_vendor']).to eq('WistronI')
    end

    it 'should be able to identify the long vendor of a patrial MAC' do
      expect(Louis.lookup(partial_mac)['long_vendor']).to eq('Wistron InfoComm(Kunshan)Co.,Ltd.')
    end

    it 'should drop the local bit when performing a lookup' do
      expect(Louis.lookup(local_mac)['short_vendor']).to eq('WistronI')
    end

    it 'should drop the multicast bit when performing a lookup' do
      expect(Louis.lookup(multicast_mac)['short_vendor']).to eq('WistronI')
    end

    it 'should return "Unknown" as the short vendor string for unknown MAC prefixes' do
      expect(Louis.lookup(unknown_mac)['short_vendor']).to eq('Unknown')
    end

    it 'should return "Unknown" as the long vendor string for unknown MAC prefixes' do
      expect(Louis.lookup(unknown_mac)['long_vendor']).to eq('Unknown')
    end
  end

  describe '#mask_keys' do
    it 'should return a list of integers: [48, 45, 44, 40, 36, 32, 28, 25, 24, 16]' do
      expect(Louis.mask_keys).to eq([48, 45, 44, 40, 36, 32, 28, 25, 24, 16])
    end
  end
end
