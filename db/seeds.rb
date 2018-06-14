# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# remove all existing objects to start fresh!
[Industry, Interest, Employer, Opportunity, EmploymentStatus, OpportunityStage, Fellow].each(&:destroy_all)

industries = [
  'Accounting', 'Advertising', 'Aerospace', 'Banking', 'Beauty / Cosmetics', 'Biotechnology', 'Business', 
  'Chemical', 'Communications', 'Computer Engineering', 'Computer Hardware', 'Education', 'Electronics', 
  'Employment / Human Resources', 'Energy', 'Fashion', 'Film', 'Financial Services', 'Fine Arts', 
  'Food & Beverage', 'Health', 'Information Technology', 'Insurance', 'Journalism / News / Media', 'Law', 
  'Management / Strategic Consulting', 'Manufacturing', 'Medical Devices & Supplies', 'Performing Arts', 
  'Pharmaceutical', 'Public Administration', 'Public Relations', 'Publishing', 'Marketing', 'Real Estate', 
  'Sports', 'Technology', 'Telecommunications', 'Tourism', 'Transportation / Travel', 'Writing'
]
    
industries.sort.each do |name|
  Industry.create!(name: name)
end

industry_accounting = Industry.find_by name: 'Accounting'

interests = [
  'Accounting', 'African American Studies', 'African Studies', 'Agriculture', 'American Indian Studies', 
  'American Studies', 'Architecture', 'Asian American Studies', 'Asian Studies', 'Dance', 'Visual Arts', 
  'Theater', 'Music', 'English / Literature', 'Film', 'Foreign Language', 'Graphic Design', 'Philosophy', 
  'Religion', 'Business', 'Marketing', 'Actuarial Science', 'Hospitality', 'Human Resources', 'Real Estate', 
  'Health', 'Public Health', 'Medicine', 'Nursing', 'Gender Studies', 'Urban Studies', 'Latin American Studies', 
  'European Studies', 'Gay and Lesbian Studies', 'Latinx Studies', 'Women’s Studies', 'Education', 'Psychology', 
  'Child Development', 'Computer Science', 'History', 'Biology', 'Cognitive Science', 'Human Biology', 
  'Diversity Studies', 'Marine Sciences', 'Maritime Studies', 'Math', 'Nutrition', 'Sports and Fitness', 
  'Law / Legal Studies', 'Military', 'Public Administration', 'Social Work', 'Criminal Justice', 'Theology', 
  'Equestrian Studies', 'Food Science', 'Urban Planning', 'Art History', 'Interior Design', 'Landscape Architecture', 
  'Chemistry', 'Physics', 'Chemical Engineering', 'Software Engineering', 'Industrial Engineering', 
  'Civil Engineering', 'Electrical Engineering', 'Mechanical Engineering', 'Biomedical Engineering', 
  'Computer Hardware Engineering', 'Anatomy', 'Ecology', 'Genetics', 'Neurosciences', 'Communications', 
  'Animation', 'Journalism', 'Information Technology', 'Aerospace', 'Geography', 'Statistics', 
  'Environmental Studies', 'Astronomy', 'Public Relations', 'Library Science', 'Anthropology', 'Economics', 
  'Criminology', 'Archaeology', 'Cartography', 'Political Science', 'Sociology', 'Construction Trades', 
  'Culinary Arts', 'Creative Writing'
]
    
interests.sort.each do |name|
  Interest.create!(name: name)
end

interest_accounting = Interest.find_by name: 'Accounting'


fruits = ['Apples', 'Bananas', 'Carrots', 'Figs', 'Oranges', 'Raspberries', 'Strawberries']

['ABC Employer', 'DEF Employer'].each do |name|
  employer = Employer.create!(name: name)
  
  Industry.where.not(name: 'Accounting').limit(2).each do |industry|
    employer.industries << industry
  end
  
  employer.industries << industry_accounting
  
  3.times do
    fruit = fruits.shift
    opportunity = employer.opportunities.create! name: fruit, description: "Buying and selling #{fruit}"
    opportunity.industries << industry_accounting
    opportunity.interests << interest_accounting
  end
end

['Unemployed', 'Quality (Grad School)', 'Quality', 'Part Quality', 'Not Quality', 'Service', 'Unknown'].each do |status|
  EmploymentStatus.create! name: status
end

opportunity_stages = OpportunityStage.create!([
  {position: 0, probability: 0.01, name: 'notified'},
  {position: 1, probability: 0.05, name: 'interested'},
  {position: 2, probability: 0.1,  name: 'applying'},
  {position: 3, probability: 0.15, name: 'application submitted'},
  {position: 4, probability: 0.95, name: 'accepted'},
  {position: 5, probability: 1.0,  name: 'committed'},
  {position: 6, probability: 0.0,  name: 'rejected'}
])

employment_status = EmploymentStatus.find_by name: 'Unemployed'

fellows = Fellow.create!([
  {first_name: 'Andy',  last_name: 'Anderson', graduation_semester: 'Spring', graduation_year: '2018', employment_status: employment_status},
  {first_name: 'Beth',  last_name: 'Barstow',  graduation_semester: 'Fall',   graduation_year: '2018', employment_status: employment_status},
  {first_name: 'Cole',  last_name: 'Coleman',  graduation_semester: 'Spring', graduation_year: '2019', employment_status: employment_status},
  {first_name: 'Debra', last_name: 'Davis',    graduation_semester: 'Fall',   graduation_year: '2019', employment_status: employment_status},
  {first_name: 'Ethan', last_name: 'Eberly',   graduation_semester: 'Spring', graduation_year: '2020', employment_status: employment_status},
])

# give each fellow three interests
Interest.where.not(name: 'Accounting').limit(fellows.size * 3).each_with_index do |interest, f|
  fellows[f % fellows.size].interests << interest
end

# give each fellow three industries
Industry.where.not(name: 'Accounting').limit(fellows.size * 3).each_with_index do |industry, f|
  fellows[f % fellows.size].industries << industry
end

# add all fellows to accounting industry/interest groups
Fellow.all.each do |fellow|
  fellow.industries << industry_accounting
  fellow.interests << interest_accounting
end