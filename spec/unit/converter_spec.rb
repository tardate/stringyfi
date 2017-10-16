require 'spec_helper'

describe StringyFi::Converter do
  subject(:converter) { described_class.new(filename) }

  context "with chromatic.xml sample" do
    let(:filename) { xml_sample_path }

    describe "#xml_doc" do
      subject { converter.xml_doc }
      it "returns the XML doc" do
        expect(subject).to be_a(Nokogiri::XML::Document)
      end
    end

    describe "#identification" do
      subject(:identification) { converter.identification }
      it "returns expected metadata" do
        expect(subject).to eql({
          title: "chromatic scale",
          encoding: {
            date: "2017-10-15",
            software: "Guitar Pro 7.0.6"
          }
        })
      end
    end

    describe "#part_list" do
      subject(:part_list) { converter.part_list }
      it "returns an array of parts" do
        expect(part_list).to eql([
          {id: "P1"}
        ])
      end
    end

    describe "#parts" do
      subject(:parts) { converter.parts }
      it "returns parts corresponding to parts list" do
        expect(parts.count).to eql(converter.part_list.count)
      end
    end

    describe "#measures" do
      subject(:measures) { converter.measures }
      it "has the correct number of measures" do
        expect(measures).to be_a(StringyFi::Measures)
        expect(measures.count).to eql(7)
      end
    end

    describe "#measure" do
      subject(:measure) { converter.measure(measure_id) }
      context "with first measure" do
        let(:measure_id) { 0 }
        it "has the correct note info" do
          expect(measure).to be_an(Array)
          expect(measure.size).to eql(1)
          expect(measure[0]).to be_a(StringyFi::Note)
          expect(measure[0].to_str).to eql("3:E:0")
        end
      end
    end

    describe "#score_preamble" do
      subject { converter.score_preamble }
      it "includes the expected identification" do
        expect(subject).to include(';** Title: chromatic scale')
      end
      it "includes the tstart" do
        expect(subject).to include("\ttstart DemoTune")
      end
    end

    describe "#score_coda" do
      subject { converter.score_coda }
      it "includes a rest and tstop" do
        expect(subject).to include("\ttrest 8")
        expect(subject).to include("\ttstop")
      end
    end

    describe "#score_body" do
      subject { converter.score_body(1/32.0) }
      it "returns the expected conversion" do
        expect(subject).to eql([
          "\t; measure 1",
          "\ttoctave -1",
          "\ttnote E1,4,0  ; 3:E:0",
          "\t; measure 2",
          "\ttnote F1,4,0  ; 3:F:0",
          "\ttnote F1S,4,0  ; 3:F:1",
          "\t; measure 3",
          "\ttnote G1,4,0  ; 3:G:0",
          "\ttnote A1,4,0  ; 3:A:0",
          "\ttnote A1S,4,0  ; 3:A:1",
          "\ttnote B1,4,0  ; 3:B:0",
          "\t; measure 4",
          "\ttoctave +1",
          "\ttnote C1,4,0  ; 4:C:0",
          "\ttnote C1S,4,0  ; 4:C:1",
          "\ttnote D1,4,0  ; 4:D:0",
          "\ttnote D1S,4,0  ; 4:D:1",
          "\t; measure 5",
          "\ttnote E1,3,0  ; 4:E:0",
          "\ttnote F1,3,0  ; 4:F:0",
          "\ttnote F1S,3,0  ; 4:F:1",
          "\ttnote G1,3,0  ; 4:G:0",
          "\ttnote G1S,3,0  ; 4:G:1",
          "\ttnote A1,3,0  ; 4:A:0",
          "\ttnote A1S,3,0  ; 4:A:1",
          "\ttnote B1,3,0  ; 4:B:0",
          "\t; measure 6",
          "\ttoctave +1",
          "\ttnote C1,2,0  ; 5:C:0",
          "\ttnote C1S,2,0  ; 5:C:1",
          "\ttnote D1,2,0  ; 5:D:0",
          "\ttnote D1S,2,0  ; 5:D:1",
          "\ttnote E1,2,0  ; 5:E:0",
          "\ttnote F1,2,0  ; 5:F:0",
          "\ttnote F1S,2,0  ; 5:F:1",
          "\ttnote G1,2,0  ; 5:G:0",
          "\ttnote G1S,2,0  ; 5:G:1",
          "\ttnote A1,2,0  ; 5:A:0",
          "\ttnote A1S,2,0  ; 5:A:1",
          "\ttnote B1,2,0  ; 5:B:0",
          "\ttoctave +1",
          "\ttnote C1,2,0  ; 6:C:0",
          "\ttnote C1S,2,0  ; 6:C:1",
          "\ttnote D1,2,0  ; 6:D:0",
          "\ttnote D1S,2,0  ; 6:D:1",
          "\t; measure 7",
          "\ttnote E1,1,0  ; 6:E:0",
          "\ttnote F1,1,0  ; 6:F:0",
          "\ttnote F1S,1,0  ; 6:F:1",
          "\ttnote G1,1,0  ; 6:G:0",
          "\ttnote G1S,1,0  ; 6:G:1",
          "\ttnote A1,1,0  ; 6:A:0",
          "\ttnote A1S,1,0  ; 6:A:1",
          "\ttnote B1,1,0  ; 6:B:0",
          "\ttoctave +1",
          "\ttnote C1,1,0  ; 7:C:0",
          "\ttnote C1S,1,0  ; 7:C:1",
          "\ttnote D1,1,0  ; 7:D:0",
          "\ttnote D1S,1,0  ; 7:D:1",
          "\ttnote E1,4,0  ; 7:E:0",
          "\ttnote E1,4,0  ; 7:E:0"
        ])
      end
    end

    describe "#convert!" do
      subject { converter.convert! }
      it "calls all the necessary bits" do
        expect(converter).to receive(:score_preamble)
        expect(converter).to receive(:score_body)
        expect(converter).to receive(:score_coda)
        expect($stderr).to receive(:puts).exactly(4).times
        expect($stdout).to receive(:puts).exactly(3).times
        subject
      end
    end

  end
end
