require "rails_helper"
require 'nokogiri'

RSpec.describe CandidateMailer, type: :mailer do
  let(:access_token) { AccessToken.for(fellow_opportunity) }

  let(:fellow_opportunity) { create :fellow_opportunity, fellow: fellow, opportunity: opportunity }
  let(:fellow) { create :fellow, contact: create(:contact, email: email) }
  let(:email) { 'test@example.com' }
  let(:opportunity) { create :opportunity, name: "New Opportunity" }

  let(:mail) { CandidateMailer.with(access_token: access_token).send(view) }
  
  def expect_status_link body, label
    expect(body).to include("http://localhost:3011/candidates/#{fellow_opportunity.id}/status?update=#{label.gsub(' ', '+')}&token=#{access_token.code}")
  end
  
  describe 'invitation' do
    let(:view) { :invitation }
    
    it { expect(mail.subject).to eq("You've been invited to apply for New Opportunity") }
    it { expect(mail.to).to include(email) }
    it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

    it "renders the body with links" do
      body = mail.body.encoded
      
      expect(body).to include(opportunity.name)
      expect_status_link body, 'interested'
      expect_status_link body, 'not interested'
    end
  end
  
  describe 'researched employer' do
    let(:view) { :researched_employer }
    
    it { expect(mail.subject).to eq("New Opportunity: Research This Employer") }
    it { expect(mail.to).to include(email) }
    it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

    it "renders the body with links" do
      body = mail.body.encoded
      
      expect(body).to include('Have you researched')
      expect_status_link body, 'researched employer'
      expect_status_link body, 'no change'
      expect_status_link body, 'skip'
      expect_status_link body, 'not interested'
    end
  
    describe 'connected with employees' do
      let(:view) { :connected_with_employees }
    
      it { expect(mail.subject).to eq("New Opportunity: Connect with Current Employees") }
      it { expect(mail.to).to include(email) }
      it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

      it "renders the body with links" do
        body = mail.body.encoded
      
        expect(body).to include('Have you networked')
        expect_status_link body, 'connected with employees'
        expect_status_link body, 'no change'
        expect_status_link body, 'skip'
        expect_status_link body, 'not interested'
      end
    end
  
    describe 'customized application materials' do
      let(:view) { :customized_application_materials }
    
      it { expect(mail.subject).to eq("New Opportunity: Customized Your Application Materials") }
      it { expect(mail.to).to include(email) }
      it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

      it "renders the body with links" do
        body = mail.body.encoded
      
        expect(body).to include('Have you customized')
        expect_status_link body, 'customized application materials'
        expect_status_link body, 'no change'
        expect_status_link body, 'skip'
        expect_status_link body, 'not interested'
      end
    end
  
    describe 'submitted application' do
      let(:view) { :submitted_application }
    
      it { expect(mail.subject).to eq("New Opportunity: Submit Your Application") }
      it { expect(mail.to).to include(email) }
      it { expect(mail.from).to include(Rails.application.secrets.mailer_from_email) }

      it "renders the body with links" do
        body = mail.body.encoded
      
        expect(body).to include('Have you submitted')
        expect_status_link body, 'submitted application'
        expect_status_link body, 'no change'
        expect_status_link body, 'skip'
        expect_status_link body, 'not interested'
      end
    end
  end
end
