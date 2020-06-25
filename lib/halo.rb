Dir["#{File.dirname(__FILE__)}/rbhalo/**/*.rb"].each { |f| load(f) }

module RbHalo
    class Error < StandardError; end

	StatusOK     = 200
	StatusIgnore = 201

	# 300: Ok so far, need more info
	StatusAuthenticate = 301

	# 400: Not good but continue
	StatusBadCommand = 401
	StatusMalformed  = 402
	StatusBadKey     = 403

	# 500: Something gone bad internally. Continue
	StatusInternal = 500

	#  600: Exit
	StatusBadAuth    = 600
	StatusClose      = 601
	StatusBadSession = 602
	StatusBadCommand = 603

end
