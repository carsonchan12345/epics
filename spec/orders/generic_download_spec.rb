RSpec.describe Epics::GenericDownload do
  let(:client) { Epics::Client.new(File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'SIZBN001.key')), 'secret', 'https://194.180.18.30/ebicsweb/ebicsweb', 'SIZBN001', 'EBIX', 'EBICS') }

  describe 'with date range' do
    subject { described_class.new(client, order_type: 'XYZ', from: '2024-01-01', to: '2024-01-31') }

    describe '#to_xml' do
      specify { expect(subject.to_xml).to be_a_valid_ebics_doc }
      
      it 'includes the custom order type' do
        expect(subject.to_xml).to include('<OrderType>XYZ</OrderType>')
      end

      it 'includes the date range' do
        expect(subject.to_xml).to include('<Start>2024-01-01</Start>')
        expect(subject.to_xml).to include('<End>2024-01-31</End>')
      end

      it 'uses DZHNN as default order attribute' do
        expect(subject.to_xml).to include('<OrderAttribute>DZHNN</OrderAttribute>')
      end
    end
  end

  describe 'without date range' do
    subject { described_class.new(client, order_type: 'ABC') }

    describe '#to_xml' do
      specify { expect(subject.to_xml).to be_a_valid_ebics_doc }
      
      it 'includes the custom order type' do
        expect(subject.to_xml).to include('<OrderType>ABC</OrderType>')
      end

      it 'includes empty StandardOrderParams when no date range' do
        expect(subject.to_xml).to include('<StandardOrderParams/>')
      end
    end
  end

  describe 'with custom order attribute' do
    subject { described_class.new(client, order_type: 'XYZ', order_attribute: 'DZNNN') }

    describe '#to_xml' do
      it 'uses the custom order attribute' do
        expect(subject.to_xml).to include('<OrderAttribute>DZNNN</OrderAttribute>')
      end
    end
  end
end
