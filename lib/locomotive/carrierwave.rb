require 'carrierwave/orm/mongoid'
require 'locomotive/carrierwave/base'
require 'locomotive/carrierwave/patches'

# register missing mime types
EXTENSIONS[:eot] = 'application/vnd.ms-fontobject'
