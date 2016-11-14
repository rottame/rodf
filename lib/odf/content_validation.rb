require 'rubygems'
require 'builder'

#require 'odf/column'
require 'odf/container'
#require 'odf/row'

module ODF
  class ContentValidation < Container
    #contains :rows, :columns

    def initialize(name, options = {})
      @options = {'table:name': name}
      @error = {}
      if options[:in_list]
        @options['table:condition'] = "of:cell-content-is-in-list(#{array_to_list(options[:in_list])})"
        @options['table:allow-empty-cell'] = !!options[:allow_empty]
        @options['table:display-list'] = options[:sorted] ? 'sort-ascending' : 'unsorted'
        @options['table:base-cell-address'] = options[:base_cell]
      end
      if @options.any?
        @error['table:message-type'] = "warning"
        @error['table:display'] = true
        if options[:error].is_a?(String) || options[:error].is_a?(Symbol)
          @error['table:message-type'] = options[:error].to_s
        end
      end
    end

    def xml
      ret = Builder::XmlMarkup.new.tag! "table:content-validation", @options do |xml|
        if @error.any?
          xml.tag! 'table:error-message', @error
        end
      end
      puts ret.inspect
      ret
    end
    protected

    def array_to_list(array)
      array.map{|i| "\"#{i}\""}.join(';')
    end
  end
end
