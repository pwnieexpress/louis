require 'spec_helper'

RSpec.describe Louis do
  it 'has a version number' do
    expect(Louis::VERSION).not_to be nil
  end

  it "it should have it's data file" do
    expect(File.readable?(Louis::OUI_FILE)).to be(true)
  end

  describe 'Format RegEx' do
    subject { Louis::OUI_FORMAT_REGEX }

    it "should ignore comment lines" do
      comment_line = "# This is just a sample of what a comment might look like"
      expect(subject).to_not match(comment_line)
    end

    it "should ignore blank lines" do
      expect(subject).to_not match("")
    end
  end
end
