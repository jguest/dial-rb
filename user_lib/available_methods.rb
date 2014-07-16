class AvailableMethods

    # methods shared by all users
    # return some kind of evaluation, message or status

    # as of now, methods here need to maintain backwards
    # compatibility so leave the signature if retiring functionality

   	# TODO enable yard documentation server
    
    # provides a link to the ruby documentation for classes and methods
    #
    # @param clazz [Class] example String.class
    # @param method [Symbol] example :upcase
    # @param scope [Symbol] :instance or :class (:static)
    # @return [String] doc url
	def doc(clazz, method = nil, scope = :instance)
		url = "http://www.ruby-doc.org/core-2.1.2/#{clazz.to_s}.html"
		if !method.nil?
			scope_lookup = {:instance => "method-i", :class => "method-c", :static => "method-c"}
			url << "##{scope_lookup[scope]}-#{method.to_s}"
		end
		"ruby doc: #{url}"
	end

end