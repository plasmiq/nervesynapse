require 'spec_helper'

describe WelcomeController do
  describe '/' do
    it 'should render index page' do
      get :index

      response.should render_template :index
    end
  end
end
