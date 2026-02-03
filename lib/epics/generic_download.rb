# frozen_string_literal: true

class Epics::GenericDownload < Epics::GenericRequest
  def header
    download_order_params = Hash.new.tap do |params|
      if options[:from] && options[:to]
        params[:DateRange] = {
          Start: options[:from],
          End: options[:to]
        }
      end
    end

    client.header_request.build(
      nonce: nonce,
      timestamp: timestamp,
      order_type: options[:order_type],
      order_attribute: options[:order_attribute] || 'DZHNN',
      order_params: download_order_params,
      mutable: { TransactionPhase: 'Initialisation' }
    )
  end
end
