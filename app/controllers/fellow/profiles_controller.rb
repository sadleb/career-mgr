class Fellow::ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:list, :combined]
  before_action :ensure_fellow!
  before_action :set_fellow

  def show
  end

  def edit
  end

  def update
    if @fellow.update(fellow_params)
      redirect_to fellow_profile_path, notice: 'Your profile was successfully updated.'
    else
      render :edit
    end
  end
  
  private
  
  def set_fellow
    unless current_user.fellow
      current_user.create_fellow(
        first_name: 'unknown',
        last_name: 'unknown',
        employment_status: EmploymentStatus.find_by(position: 0)
      )
    end
    
    @fellow = current_user.fellow
  end
  
  def fellow_params
    params.require(:fellow).permit(
      :key, :first_name, :last_name, :graduation_year, :graduation_semester,
      :major, :affiliations, :linkedin_url,
      :employment_status_id, :industry_tags, :interest_tags, :metro_tags, :industry_interest_tags,
      industry_ids: [], interest_ids: [], metro_ids: [],
      contact_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url]
    )
  end
end