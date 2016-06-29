class StudiesController < ApplicationController
  before_action :set_study, only: [:show, :edit, :update, :destroy]


###
# So the idea here is that height and weight must be provided, but 'likes' (which is the pet they like), is optional
# If 'likes' is left off, it will be added to the outgoing record, but not saved
# If given, it will be saved, and a new statistical threshold will be calculated
###

  protect_from_forgery with: :null_session

  # GET /studies
  # GET /studies.json
  def index
	Study.adjustThreshold
    @studies = Study.all
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
  end

  # GET /studies/new
  def new
    @study = Study.new
  end

  # GET /studies/1/edit
  def edit
  end


  # POST /studies
  # POST /studies.json
  def create
    @study = Study.new(study_params)

    respond_to do |format|
      if @study.save
		if not @study.autoSetLikes  # do after saving, because we don't want to save guesses
			Study.adjustThreshold
		end
		puts 'Create'
		puts @study.likes
        format.html { redirect_to @study, notice: 'Study was successfully created.' }
        format.json { render :show, status: :created, location: @study }
      else
        format.html { render :new }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /studies/1
  # PATCH/PUT /studies/1.json
  def update
    respond_to do |format|
      if @study.update(study_params)
		if not @study.autoSetLikes # do after saving, because we don't want to save guesses
			Study.adjustThreshold
		end
        format.html { redirect_to @study, notice: 'Study was successfully updated.' }
        format.json { render :show, status: :ok, location: @study }
      else
        format.html { render :edit }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    @study.destroy
	Study.adjustThreshold # readjust after destruction
    respond_to do |format|
      format.html { redirect_to studies_url, notice: 'Study was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study
      @study = Study.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_params
      params.require(:study).permit(:height, :weight, :likes)
    end



end
