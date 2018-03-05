require 'fluent/output'
require 'rest-client'

module Fluent
    class BaritoOutput < BufferedOutput
      Fluent::Plugin.register_output("barito", self)

      config_param :use_https, :bool, :default => false

      def start
        super
        @protocol = 'http'
      end

      def send_message(url, message)
        if @use_https
          @protocol = 'https'
        end

        RestClient.post "#{@protocol}://#{url}", message, {content_type: :json}
      end

      def format(tag, time, record)
        [tag, time, record].to_msgpack
      end

      def write(chunk)
        chunk.msgpack_each {|(tag, time, record)|
          next unless record.is_a? Hash
          kubernetes = record['kubernetes']
          next unless not kubernetes['labels'].nil?
          barito_stream_id = kubernetes['labels']['baritoStreamId']
          unless barito_stream_id.nil? || barito_stream_id == ''
            message = record.to_json
            barito_produce_host = kubernetes['labels']['baritoProduceHost']
            barito_produce_port = kubernetes['labels']['baritoProducePort']
            barito_produce_topic = kubernetes['labels']['baritoProduceTopic']
            barito_store_id = kubernetes['labels']['baritoStoreId']
            barito_forwarder_id = kubernetes['labels']['baritoForwarderId']
            barito_client_id = kubernetes['labels']['baritoClientId']
            url = "#{barito_produce_host}:#{barito_produce_port}/str/#{barito_stream_id}/st/#{barito_store_id}/fw/#{barito_forwarder_id}/cl/#{barito_client_id}/produce/#{barito_produce_topic}"

            send_message(url, message)
          end
        }
      end
    end
end
