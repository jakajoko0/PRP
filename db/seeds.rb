# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#begin
#(1..20).each do |fnum| 
  #Franchise.create(	
  #  area: "1",
  #  mast: "0",
  #  region: 1,
  #  franchise_number: "%03d" % fnum,
  #  office: "01",
  #  firm_id: "123456",
  #  salutation: Faker::Name.prefix,
  #  lastname: Faker::Name.last_name,
  #  firstname: Faker::Name.first_name,
  #  initial: Faker::Name.middle_name[0],
  #  address: Faker::Address.street_address,
  #  address2: Faker::Address.building_number,
  #  city: Faker::Address.city,
  #  state: Faker::Address.state_abbr,
  #  zip_code: Faker::Address.zip,
  #  email: "franchise#{fnum}@smallbizpros.com",
  #  ship_address: Faker::Address.street_address,
   # ship_address2: "",
   ## ship_city: Faker::Address.city,
  #  ship_state: Faker::Address.state_abbr,
  #  ship_zip_code: Faker::Address.zip,
  #  home_address: Faker::Address.street_address,
  #  home_address2: "",
 #   home_city: Faker::Address.city,
 #   home_state: Faker::Address.state_abbr,
 #   home_zip_code: Faker::Address.zip,
 #   phone: Faker::PhoneNumber.phone_number,
 #   phone2: Faker::PhoneNumber.phone_number,
 #   fax: Faker::PhoneNumber.phone_number,
 #   mobile: Faker::PhoneNumber.cell_phone,
 #   alt_email: Faker::Internet.safe_email,
 #   start_date: (Date.today-1.year),
 #   renew_date: (Date.today+5.year),
 #   term_date: nil,
#     term_reason: "",
#     salesman: Faker::Name.name,
#     territory: "Some Greater Area",
#     start_zip: Faker::Address.zip,
#     stop_zip: Faker::Address.zip,
#     prior_year_rebate: Faker::Number.decimal(l_digits: 4, r_digits: 2),
#     advanced_rebate: Faker::Number.decimal(l_digits: 1, r_digits: 1),
#     show_exempt_collect: 0,
#     inactive: 0,
#     non_compliant: 0,
#     non_compliant_reason: "",
#     max_collections: 0.00,
#     avg_collections: 0.00,
#     max_coll_year: 0,
#     max_coll_month: 0)
# end
#end

#begin
#Franchise.all.each do |f|
#  f.create_insurance(eo_insurance: 0, gen_insurance: 0, other_insurance: 0 , other_description: nil, eo_expiration: nil, gen_expiration: nil, other_expiration: nil)
#end
#end

Region.create({ "id" => 1, "region_id"=>1, "region_number"=>"01", "area"=>"1", "description"=>"Southeast"})
Region.create({ "id" => 2,"region_id"=>2, "region_number"=>"02", "area"=>"1", "description"=>"Mid-Atlantic"})
Region.create({ "id" => 3,"region_id"=>3, "region_number"=>"03", "area"=>"1", "description"=>"Northeast Corridor"})
Region.create({ "id" => 4,"region_id"=>4, "region_number"=>"04", "area"=>"1", "description"=>"Mid-US"})
Region.create({ "id" => 5,"region_id"=>5, "region_number"=>"05", "area"=>"1", "description"=>"PBS West"})
Region.create({ "id" => 6,"region_id"=>19, "region_number"=>"19", "area"=>"1", "description"=>"Processing Centers"})
Region.create({ "id" => 7,"region_id"=>20, "region_number"=>"20", "area"=>"1", "description"=>"Corporate"})
Region.create({ "id" => 8,"region_id"=>0, "region_number"=>"00", "area"=>"1", "description"=>"Home Office"})

RegionState.create({"id"=>1, "region_id"=>1, "state_abb"=>"AL", "state"=>"Alabama"})
RegionState.create({"id"=>2, "region_id"=>1, "state_abb"=>"FL", "state"=>"Florida"})
RegionState.create({"id"=>3, "region_id"=>1, "state_abb"=>"GA", "state"=>"Georgia"})
RegionState.create({"id"=>4, "region_id"=>1, "state_abb"=>"SC", "state"=>"South Carolina"})
RegionState.create({"id"=>5, "region_id"=>2, "state_abb"=>"DE", "state"=>"Delaware"})
RegionState.create({"id"=>6, "region_id"=>2, "state_abb"=>"KY", "state"=>"Kentucky"})
RegionState.create({"id"=>7, "region_id"=>2, "state_abb"=>"MD", "state"=>"Maryland"})
RegionState.create({"id"=>8, "region_id"=>2, "state_abb"=>"NJ", "state"=>"New Jersey"})
RegionState.create({"id"=>9, "region_id"=>2, "state_abb"=>"NC", "state"=>"North Carolina"})
RegionState.create({"id"=>10, "region_id"=>2, "state_abb"=>"OH", "state"=>"Ohio"})
RegionState.create({"id"=>11, "region_id"=>2, "state_abb"=>"TN", "state"=>"Tennessee"})
RegionState.create({"id"=>12, "region_id"=>2, "state_abb"=>"VA", "state"=>"Virgina"})
RegionState.create({"id"=>13, "region_id"=>2, "state_abb"=>"WV", "state"=>"West Virgina"})
RegionState.create({"id"=>14, "region_id"=>3, "state_abb"=>"CT", "state"=>"Connecticut"})
RegionState.create({"id"=>15, "region_id"=>3, "state_abb"=>"IL", "state"=>"Illinois"})
RegionState.create({"id"=>16, "region_id"=>3, "state_abb"=>"ME", "state"=>"Maine"})
RegionState.create({"id"=>17, "region_id"=>3, "state_abb"=>"MA", "state"=>"Massachusetts"})
RegionState.create({"id"=>18, "region_id"=>3, "state_abb"=>"MI", "state"=>"Michigan"})
RegionState.create({"id"=>19, "region_id"=>3, "state_abb"=>"NH", "state"=>"New Hampshire"})
RegionState.create({"id"=>20, "region_id"=>3, "state_abb"=>"NY", "state"=>"New York"})
RegionState.create({"id"=>21, "region_id"=>3, "state_abb"=>"PA", "state"=>"Pennsylvania"})
RegionState.create({"id"=>22, "region_id"=>3, "state_abb"=>"RI", "state"=>"Rhode Island"})
RegionState.create({"id"=>23, "region_id"=>3, "state_abb"=>"VT", "state"=>"Vermont"})
RegionState.create({"id"=>24, "region_id"=>4, "state_abb"=>"AR", "state"=>"Arkansas"})
RegionState.create({"id"=>25, "region_id"=>4, "state_abb"=>"CA", "state"=>"California"})
RegionState.create({"id"=>26, "region_id"=>4, "state_abb"=>"IN", "state"=>"Indiana"})
RegionState.create({"id"=>27, "region_id"=>4, "state_abb"=>"IA", "state"=>"Iowa"})
RegionState.create({"id"=>28, "region_id"=>4, "state_abb"=>"LA", "state"=>"Louisiana"})
RegionState.create({"id"=>29, "region_id"=>4, "state_abb"=>"MO", "state"=>"Missouri"})
RegionState.create({"id"=>30, "region_id"=>4, "state_abb"=>"MN", "state"=>"Minnesota"})
RegionState.create({"id"=>31, "region_id"=>4, "state_abb"=>"MS", "state"=>"Mississippi"})
RegionState.create({"id"=>32, "region_id"=>4, "state_abb"=>"NE", "state"=>"Nebraska"})
RegionState.create({"id"=>33, "region_id"=>4, "state_abb"=>"OK", "state"=>"Oklahoma"})
RegionState.create({"id"=>34, "region_id"=>4, "state_abb"=>"TX", "state"=>"Texas"})
RegionState.create({"id"=>35, "region_id"=>4, "state_abb"=>"WI", "state"=>"Wisconsin"})
RegionState.create({"id"=>36, "region_id"=>5, "state_abb"=>"AK", "state"=>"Alaska"})
RegionState.create({"id"=>37, "region_id"=>5, "state_abb"=>"AZ", "state"=>"Arizona"})
RegionState.create({"id"=>38, "region_id"=>5, "state_abb"=>"CO", "state"=>"Colorado"})
RegionState.create({"id"=>39, "region_id"=>5, "state_abb"=>"HI", "state"=>"Hawaii"})
RegionState.create({"id"=>40, "region_id"=>5, "state_abb"=>"ID", "state"=>"Iadho"})
RegionState.create({"id"=>41, "region_id"=>5, "state_abb"=>"KS", "state"=>"Kansas"})
RegionState.create({"id"=>42, "region_id"=>5, "state_abb"=>"MT", "state"=>"Montana"})
RegionState.create({"id"=>43, "region_id"=>5, "state_abb"=>"NV", "state"=>"Nevada"})
RegionState.create({"id"=>44, "region_id"=>5, "state_abb"=>"NM", "state"=>"New Mexico"})
RegionState.create({"id"=>45, "region_id"=>5, "state_abb"=>"ND", "state"=>"North Dakota"})
RegionState.create({"id"=>46, "region_id"=>5, "state_abb"=>"OR", "state"=>"Oregon"})
RegionState.create({"id"=>47, "region_id"=>5, "state_abb"=>"SD", "state"=>"South Dakota"})
RegionState.create({"id"=>48, "region_id"=>5, "state_abb"=>"UT", "state"=>"Utah"})
RegionState.create({"id"=>49, "region_id"=>5, "state_abb"=>"WA", "state"=>"Washington"})
RegionState.create({"id"=>50, "region_id"=>5, "state_abb"=>"WY", "state"=>"Wyoming"})


Admin.create({"id"=>1, "email"=>"dgrenier@smallbizpros.com", "password"=>"tabarnack16"})
