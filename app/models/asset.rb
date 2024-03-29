class Asset 
  
  include Mongoid::Document
  include Mongoid::Timestamps    
  
  ## Extensions ##  
  include Models::Extensions::Asset::Vignette
  include CustomFields::ProxyClassEnabler
  
  ## fields ##
  field :name, :type => String
  field :content_type, :type => String
  field :width, :type => Integer
  field :height, :type => Integer
  field :size, :type => Integer
  field :position, :type => Integer, :default => 0
  mount_uploader :source, AssetUploader
    
  ## associations ##
  embedded_in :collection, :class_name => 'AssetCollection', :inverse_of => :assets
  
  ## validations ##
  validates_presence_of :name, :source
  
  ## behaviours ##

  ## methods ##
  
  %w{image stylesheet javascript pdf video audio}.each do |type|
    define_method("#{type}?") do
      self.content_type == type
    end  
  end
  
  def to_liquid
    { :url => self.source.url }.merge(self.attributes)
  end
    
end