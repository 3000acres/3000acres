class SitesController < ApplicationController
  before_action :load_site, only: :create
  load_and_authorize_resource

  before_action :set_site, only: [:show, :edit, :update, :destroy]

  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.all
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    if current_user
      @watch = Watch.where(:site_id => @site.id, :user_id => current_user.id).first || nil
      @post = Post.new()
      @currentuser = "true"
    end
  end

  # GET /sites/new
  def new
    @site = Site.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)
    @site.added_by_user = current_user
    unless can? :set_status, Site
      @site.status = "unknown"
    end

    respond_to do |format|
      if @site.save
        add_another_link = view_context.link_to "Add another", new_site_path, :class => 'btn btn-default'
        format.html { redirect_to @site, notice: "Site was successfully created. #{add_another_link}" }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:name, :description, :address,
          :suburb, :latitude, :longitude, :size, :water,
          :available_until, :status, :local_government_area_id, :website)
    end

    # the following is needed to make CanCan work under Rails 4; see
    # https://github.com/ryanb/cancan/issues/835
    def load_site
      @site = Site.new(site_params)
    end
end
