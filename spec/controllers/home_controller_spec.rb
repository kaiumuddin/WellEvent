RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template('index') }
    
  end
end
