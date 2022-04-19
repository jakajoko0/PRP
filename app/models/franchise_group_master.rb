class FranchiseGroupMaster < ActiveRecord::Base

  has_many :franchise_group_details, :dependent => :destroy

  validates_presence_of :group_handle, message: "Group ID cannot be blank"
  validates :group_handle, format: { without: /\s/ , message: "Group ID cannot contain a space"}
  validates_presence_of :group_description,  message: "Group Description cannot be blank"

  validates_associated :franchise_group_details, :message => "Error detected when validating group detail "

  accepts_nested_attributes_for :franchise_group_details, :allow_destroy => true


  def self.get_franchise_ids(group_id)

    sql = <<-SQL
    (select franchise_id as franchise_id from franchise_group_details
    where franchise_group_masters_id = ? )
    UNION
    (select franchises.id
    from franchises
    where franchises.franchise_number in (select franchise_number from franchise_consolidations
    WHERE franchise_id IN (Select franchise_id from franchise_group_details where franchise_group_masters_id = ? )))
    SQL

   FranchiseGroupMaster.find_by_sql([sql,group_id,group_id])
  end
end


