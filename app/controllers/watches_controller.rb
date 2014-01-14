class WatchesController < ApplicationController
  before_action :load_watch, only: :create
  load_and_authorize_resource

  before_action :set_watch, only: [:show, :edit, :update, :destroy]

  # GET /watches
  # GET /watches.json
  def index
    @watches = Watch.all
  end

  # GET /watches/1
  # GET /watches/1.json
  def show
  end

  # GET /watches/new
  def new
    @watch = Watch.new
  end

  # GET /watches/1/edit
  def edit
  end

  # POST /watches
  # POST /watches.json
  def create
    @watch = Watch.new(watch_params)

    respond_to do |format|
      if @watch.save
        add_another_link = view_context.link_to "Add another", new_watch_path, :class => 'btn btn-default'
        format.html { redirect_to @watch, notice: "Watch was successfully created. #{add_another_link}" }
        format.json { render action: 'show', status: :created, location: @watch }
      else
        format.html { render action: 'new' }
        format.json { render json: @watch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watches/1
  # PATCH/PUT /watches/1.json
  def update
    respond_to do |format|
      if @watch.update(watch_params)
        format.html { redirect_to @watch, notice: 'Watch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @watch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watches/1
  # DELETE /watches/1.json
  def destroy
    @watch.destroy
    respond_to do |format|
      format.html { redirect_to watches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watch
      @watch = Watch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def watch_params
      params.require(:watch).permit(:site_id)
    end

    # the following is needed to make CanCan work under Rails 4; see
    # https://github.com/ryanb/cancan/issues/835
    def load_watch
      @watch = Watch.new(watch_params)
    end
end
