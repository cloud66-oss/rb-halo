module RbHalo
	class Response
		attr_reader :status
		attr_reader :msg

		def initialize(status, msg)
			@status = status
			@msg = msg
		end

		def self.parse(content)
			raise ::RbHalo::Error.new "invalid message from the server. is it running with TLS enabled?" unless content

			parts = content.split(" ")
			raise ::RbHalo::Error.new "malformed response" if parts.count < 1

			code_text = parts[0]
			code = code_text.to_i

			msg = parts[1..-1].join(" ")

			return RbHalo::Response.new(code, msg)
		end
	end
end
