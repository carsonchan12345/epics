RSpec.describe Epics::GenericUpload do
  let(:client) { Epics::Client.new(File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'SIZBN001.key')), 'secret', 'https://194.180.18.30/ebicsweb/ebicsweb', 'SIZBN001', 'EBIX', 'EBICS') }
  let(:document) { File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'xml', 'cd1.xml')) }

  describe 'with default order attribute' do
    subject { described_class.new(client, document, order_type: 'XYZ') }

    describe '#to_xml' do
      specify { expect(subject.to_xml).to be_a_valid_ebics_doc }
      
      it 'includes the custom order type' do
        expect(subject.to_xml).to include('<OrderType>XYZ</OrderType>')
      end

      it 'uses OZHNN as default order attribute' do
        expect(subject.to_xml).to include('<OrderAttribute>OZHNN</OrderAttribute>')
      end
    end

    describe '#to_transfer_xml' do
      before { subject.transaction_id = SecureRandom.hex(16) }

      specify { expect(subject.to_transfer_xml).to be_a_valid_ebics_doc }
    end
  end

  describe 'with custom order attribute' do
    subject { described_class.new(client, document, order_type: 'ABC', order_attribute: 'UZHNN') }

    describe '#to_xml' do
      specify { expect(subject.to_xml).to be_a_valid_ebics_doc }
      
      it 'includes the custom order type' do
        expect(subject.to_xml).to include('<OrderType>ABC</OrderType>')
      end

      it 'uses the custom order attribute' do
        expect(subject.to_xml).to include('<OrderAttribute>UZHNN</OrderAttribute>')
      end
    end
  end
end
