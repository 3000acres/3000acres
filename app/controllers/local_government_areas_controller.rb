class LocalGovernmentAreasController < ApplicationController
  before_action :load_local_government_area, only: :create
  load_and_authorize_resource

  before_action :set_local_government_area, only: [:show, :edit, :update, :destroy]

  # GET /local_government_areas
  # GET /local_government_areas.json
  def index
    @local_government_areas = LocalGovernmentArea.all
  end

  # GET /local_government_areas/1
  # GET /local_government_areas/1.json
  def show
  end

  # GET /local_government_areas/new
  def new
    @local_government_area = LocalGovernmentArea.new
  end

  # GET /local_government_areas/1/edit
  def edit
  end

  # POST /local_government_areas
  # POST /local_government_areas.json
  def create
    @local_government_area = LocalGovernmentArea.new(local_government_area_params)

    respond_to do |format|
      if @local_government_area.save
        format.html { redirect_to @local_government_area, notice: 'Local government area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @local_government_area }
      else
        format.html { render action: 'new' }
        format.json { render json: @local_government_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /local_government_areas/1
  # PATCH/PUT /local_government_areas/1.json
  def update
    respond_to do |format|
      if @local_government_area.update(local_government_area_params)
        format.html { redirect_to @local_government_area, notice: 'Local government area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @local_government_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /local_government_areas/1
  # DELETE /local_government_areas/1.json
  def destroy
    @local_government_area.destroy
    respond_to do |format|
      format.html { redirect_to local_government_areas_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local_government_area
      @local_government_area = LocalGovernmentArea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def local_government_area_params
      params.require(:local_government_area).permit(:name)
    end

    # the following is needed to make CanCan work under Rails 4; see
    # https://github.com/ryanb/cancan/issues/835
    def load_local_government_area
      @local_government_area = LocalGovernmentArea.new(local_government_area_params)
    end
end
