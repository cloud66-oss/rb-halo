module RbHalo
	class Client

		require 'socket'
		require 'openssl'

		attr_reader :tls
		attr_reader :skip_tls_verify
		attr_reader :port
		attr_reader :host
		attr_reader :token

		def initialize(socket, options)
			@socket = socket
			@options = options

			@skip_tls_verify = options[:skip_tls_verify]
			@tls = options[:tls]
			@port = options[:port]
			@host = options[:host]
			@token = options[:token]
		end

		def self.connect(host, options = {})
			port = options[:port] || 15443
			skip_tls_verify = options.has_key?(:skip_tls_verify) ? options[:skip_tls_verify] : false
			tls = options.has_key?(:tls) ? options[:tls] : false

			if tls
				sock = TCPSocket.new(host, port)
				ctx = OpenSSL::SSL::SSLContext.new
				ctx.set_params(verify_mode: (skip_tls_verify ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER))
				socket = OpenSSL::SSL::SSLSocket.new(sock, ctx).tap do |s|
					s.sync_close = true
					s.connect
				end
			else
				socket = TCPSocket.open(host, port)
			end

			client = Client.new(socket, options.merge({ port: port, skip_tls_verify: skip_tls_verify, tls: tls }))
			resp = client.send_command_with_auth("conn")
			if resp.status != RbHalo::StatusOK
				raise RbHalo::Error.new "connection rejected by the server " + resp.msg
			end

			return client
		end

		def close
			@socket.close
		end

		def log(key, session, payload)
			return send_command_with_auth("log", session + " " + key + " " + payload)
		end

		def close_session(key, session)
			return send_command_with_auth("close", session + " " + key)
		end

		def send_command(command, payload = "")
			return write(command + " " + payload + "\n")
		end

		def send_command_with_auth(command, payload = "")
			resp = send_command(command, payload)
			if resp.status == RbHalo::StatusAuthenticate
				auth_resp = authenticate
				return auth_resp if auth_resp.status != RbHalo::StatusOK
			end

			# authenticated. try again
			return send_command(command, payload)
		end

		def write(content)
			@socket.write(content)
			result = @socket.gets

			return RbHalo::Response.parse(result)
		end

		def authenticate
			raise ::RbHalo::Error.new "no token provided. use options[:token] to set one" unless @token

			return send_command("auth", @token)
		end
	end
end
