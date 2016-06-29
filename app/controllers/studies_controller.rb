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
	adjustThreshold
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
		if not autoSetLikes # do after saving, because we don't want to save guesses
			adjustThreshold
		end
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
		if not autoSetLikes  # do after saving, because we don't want to save guesses
			adjustThreshold
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
	adjustThreshold # readjust after destruction
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

	# Guess is based on a height / weight ratio.  Threshold for choice is determined as the midpoint between the mean ratios
	# of both categories 'Cats' 'Dogs'

	# adjust the threshold based on new or updated records
	# Note that this is not really scalable for a large amount of data.  Would be better implemented with a record
	# containing the derivative data that could be updated on the fly.
	# The wrong way would be to keep the derivative data in resident memory, as this would not scale on multiple instances of server

	@@THRESHOLD = 0

	def adjustThreshold
		studies = Study.all
		# calc average of each 'likes' as a group
		groups = studies.group_by { |study| study.likes }
		groups.each do |k,v|
			groups[k] = v.inject(0.0) { |tot, study| tot+( study.height.to_f / study.weight.to_f ) } / v.length.to_f
		end
		@@THRESHOLD = ( groups['cats'] - groups['dogs']) / 2 + groups['dogs'] # get midpoint
		puts "New Threshold #{@@THRESHOLD}"
	end

	# set the likes based on a guess, only if value isn't present, return true if auto-set
	def autoSetLikes
		if @study.likes.nil? || @study.likes.empty?
			@study.likes = guess
			return true
		end
		return false
	end



	# Guess the 'like' for the current study
	def guess
		ratio = ( @study.height.to_f / @study.weight.to_f )
		if ratio > @@THRESHOLD
			return 'cats'
		end
		return 'dogs'
	end


end
