require 'json'

module JSONLib

	def default_key(key)
		@@default_key = key
	end

	def wrap(data, key = nil)
		{(key || @@default_key) => data}.to_json
	end

end