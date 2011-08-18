require_relative "flatten-xml"

describe NilClass, 'blank?' do
  it "returns true" do
    nil.should be_blank
  end
end

describe String, 'blank?' do
  it "returns true for blank strings" do
    ["", "  ", "\t  "].each do |s|
      s.should be_blank
    end
  end
  it "returns false for non blank strings" do
    ["a", "abc  ", "\ta  "].each do |s|
      s.should_not be_blank
    end
  end
end

describe FlattenXml, 'linearize' do
  in_out = {
    "<root>a</root>" => "root=a",
    "<config>
      
     </config>" => nil,
     "<config>
        <was>
          <debug>true</debug>
        </was>
      </config>" => "config.was.debug=true",
      "<config>
         <was>
           <debug>true</debug>
           <sucks>true</sucks>
         </was>
       </config>" => "config.was.debug=true\n" <<
                      "config.was.sucks=true",
      "<config>
         <was>
           <debug>true</debug>
           <sucks>true</sucks>
         </was>
         <port>9103</port>
       </config>" => "config.was.debug=true\n" <<
                     "config.was.sucks=true\n" <<
                     "config.port=9103"
  }
  it "linearizes simple XMLs" do
    in_out.each_pair do |input, expected|
      FlattenXml.process(input).should == expected
    end
  end
end
