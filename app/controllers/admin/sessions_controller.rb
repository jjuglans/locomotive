module Admin
  class SessionsController < Devise::SessionsController
    
    include Locomotive::Routing::SiteDispatcher

    layout 'admin/login'
  
    before_filter :require_site
    
    helper 'admin/base', 'admin/login'
  
    protected
  
    def after_sign_in_path_for(resource)
      admin_pages_url
    end
  
  end
end