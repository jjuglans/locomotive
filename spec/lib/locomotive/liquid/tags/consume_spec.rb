require 'spec_helper'

describe Locomotive::Liquid::Tags::Consume do
  
  context '#validating syntax' do
    
    it 'validates a basic syntax' do
      markup = 'blog from "http://blog.locomotiveapp.org"'
      lambda do
        Locomotive::Liquid::Tags::Consume.new('consume', markup, ["{% endconsume %}"])
      end.should_not raise_error
    end
    
    it 'validates more complex syntax with attributes' do
      markup = 'blog from "http://www.locomotiveapp.org" username: "john", password: "easyone"'
      lambda do
        Locomotive::Liquid::Tags::Consume.new('consume', markup, ["{% endconsume %}"])
      end.should_not raise_error
    end

    it 'raises an error if the syntax is incorrect' do
      markup = 'blog from http://www.locomotiveapp.org'
      lambda do
        Locomotive::Liquid::Tags::Consume.new('consume', markup, ["{% endconsume %}"])
      end.should raise_error
    end
    
  end
    
  context '#rendering' do
    
    it 'puts the response into the liquid variable' do
      Locomotive::Httparty::Webservice.stubs(:get).returns({ 'title' => 'Locomotive rocks !' })
      template = "{% consume blog from \"http://blog.locomotiveapp.org/api/read\" %}{{ blog.title }}{% endconsume %}"
      Liquid::Template.parse(template).render.should == 'Locomotive rocks !'
    end
    
  end
  
end