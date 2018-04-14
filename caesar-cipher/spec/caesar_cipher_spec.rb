require 'caesar_cipher'

describe "caesar_cipher" do
  context "with empty string and random shift passed" do
    it "returns empty string" do
      expect(caesar_cipher("", 3)).to eql("")
    end
  end

  context "with a string and 5 as shift passed" do
    it "returns string in which just letters are shifted by 5" do
      expect(caesar_cipher("What a string!", 5)).to eql("Bmfy f xywnsl!")
    end
  end

  context "given string with only whitespace chars" do
    it "returns that string untouched" do
      expect(caesar_cipher("  \n\t", 2)).to eql("  \n\t")
    end
  end

  context "given string with different case letters" do
    it "returns a string with shifted but same case (as in original string) letters" do
      expect(caesar_cipher("HeLLo", 2)).to eql("JgNNq")
    end
  end

  context "given string which includes last alphabet letters" do
    it "returns correctly modified string" do
      expect(caesar_cipher("zxuyasd", 5)).to eql("eczdfxi")
    end
  end
end
