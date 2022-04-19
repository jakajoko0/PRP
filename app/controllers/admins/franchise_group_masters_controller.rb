# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Financial Reports
class Admins::FranchiseGroupMastersController < ApplicationController
  before_action :set_group , only: %i[edit update destroy show]

  def index
    @groups = FranchiseGroupMaster.includes([franchise_group_details: [franchise: [:franchise_consolidations]]])
  end

  def new
    @group = FranchiseGroupMaster.new
    details = @group.franchise_group_details.build
  end

  def create
    @group = FranchiseGroupMaster.new(group_params)
    if @group.save
      flash[:success] = "Group created successfully!"
      redirect_to admins_franchise_group_masters_path
    else
      render :new
    end
  end

  def edit
  end

  def update

  end

  

  def destroy

  end

  def show; end

  def audit
  end

  private  

  def set_group
    @group = FranchiseGroupMaster.find(params[:id])
  end

  def group_params
    params.require(:franchise_group_master)
      .permit(:group_handle,:group_description, franchise_group_details_attributes:[:franchise_id, :id, :_destroy] )
  end


end
