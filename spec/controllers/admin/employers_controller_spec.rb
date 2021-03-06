require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Admin::EmployersController, type: :controller do
  render_views
  
  let(:user) { create :admin_user }
  
  before { sign_in user }

  # This should return the minimal set of attributes required to create a valid
  # Employer. As you add validations to Employer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { attributes_for(:employer).merge(employer_partner: true) }
  let(:invalid_attributes) { {name: ''} }
  
  let(:industry) { create :industry }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EmployersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'when signed-in user is not admin' do
    let(:user) { create :fellow_user }

    it "redirects GET #index to home" do
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects GET #show to home" do
      get :show, params: {id: '1001'}, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it "redirects GET #new to home" do
      get :new, params: {}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects GET #edit to home" do
      get :edit, params: {id: '1001'}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects POST #create to home" do
      post :create, params: {employer: valid_attributes}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects PUT #update to home" do
      put :update, params: {id: '1001', employer: valid_attributes}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
    
    it "redirects DELETE #destroy to home" do
      delete :destroy, params: {id: '1001'}, session: valid_session
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #index" do
    it "returns a success response" do
      employer = Employer.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      employer = Employer.create! valid_attributes
      get :show, params: {id: employer.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
    
    it "sets the redirect session variable when requested" do
      get :new, params: {redirect: 'new_opportunity'}, session: valid_session
      expect(response).to be_successful
      expect(session[:requested_redirect]).to eq('new_opportunity')
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      employer = Employer.create! valid_attributes
      get :edit, params: {id: employer.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Employer" do
        expect {
          post :create, params: {employer: valid_attributes}, session: valid_session
        }.to change(Employer, :count).by(1)
      end

      it "redirects to the created employer" do
        post :create, params: {employer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(admin_employer_path(Employer.last))
      end
      
      it "redirects to new opporunity if requested" do
        post :create, params: {employer: valid_attributes}, session: valid_session.merge(requested_redirect: 'new_opportunity')
        expect(response).to redirect_to(new_admin_employer_opportunity_path(Employer.last))
      end

      it "associates specified industries with the employer" do
        post :create, params: {employer: valid_attributes.merge(industry_ids: [industry.id.to_s])}, session: valid_session
        expect(Employer.last.industries).to include(industry)
      end
      
      it "sets employer partner status" do
        post :create, params: {employer: valid_attributes}, session: valid_session
        employer = Employer.last
        
        expect(employer.employer_partner).to eq(true)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {employer: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_name) { valid_attributes[:name] + ' 2' }
      let(:new_attributes) { {name: new_name} }

      it "updates the requested employer" do
        employer = Employer.create! valid_attributes
        put :update, params: {id: employer.to_param, employer: new_attributes}, session: valid_session
        employer.reload
        
        expect(employer.name).to eq(new_name)
      end

      it "redirects to the employer" do
        employer = Employer.create! valid_attributes
        put :update, params: {id: employer.to_param, employer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(admin_employer_path(employer))
      end
      
      it "associates the industry with the employer" do
        employer = Employer.create! valid_attributes
        put :update, params: {id: employer.to_param, employer: new_attributes.merge(industry_ids: [industry.id.to_s])}, session: valid_session
        employer.reload
        
        expect(employer.industries).to include(industry)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        employer = Employer.create! valid_attributes
        put :update, params: {id: employer.to_param, employer: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested employer" do
      employer = Employer.create! valid_attributes
      expect {
        delete :destroy, params: {id: employer.to_param}, session: valid_session
      }.to change(Employer, :count).by(-1)
    end

    it "redirects to the employers list" do
      employer = Employer.create! valid_attributes
      delete :destroy, params: {id: employer.to_param}, session: valid_session
      expect(response).to redirect_to(admin_employers_url)
    end
  end

end
