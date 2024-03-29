require 'carrierwave'

module CarrierWave
  
  class SanitizedFile
    
    def original_filename=(filename)
      @original_filename = filename
    end
    
    def content_type=(content_type)
      @content_type = content_type
    end
   
    # http://github.com/jnicklas/carrierwave/issuesearch?state=closed&q=content+type#issue/48
    def copy_to_with_content_type(new_path, permissions=nil)
      new_file = self.copy_to_without_content_type(new_path, permissions)
      new_file.content_type = self.content_type
      new_file
    end
    
    alias_method_chain :copy_to, :content_type
    
    # FIXME (Did) CarrierWave speaks mime type now
    def content_type
      return @content_type if @content_type
      if @file.respond_to?(:content_type) and @file.content_type
        @file.content_type.chomp
      else
        File.mime_type?(@file) if @file.is_a?(String)
      end
    end
    
  end
  
end

module CarrierWave
  module Mongoid
    def validates_integrity_of(*attrs)
      options = attrs.last.is_a?(Hash) ? attrs.last : {}
      options[:message] ||= I18n.t('carrierwave.errors.integrity', :default => 'is not an allowed type of file.')
      validates_each(*attrs) do |record, attr, value|
        record.errors.add attr, options[:message] if record.send("#{attr}_integrity_error")
      end
    end
    
    def validates_processing_of(*attrs)
      options = attrs.last.is_a?(Hash) ? attrs.last : {}
      options[:message] ||= I18n.t('carrierwave.errors.processing', :default => 'failed to be processed.')
      validates_each(*attrs) do |record, attr, value|
        record.errors.add attr, options[:message] if record.send("#{attr}_processing_error")
      end
    end
  end
end
