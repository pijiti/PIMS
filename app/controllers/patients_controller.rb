class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]


  def index
    @patients = Patient.all
     new
  end

  def new
    @patient = Patient.new
    @titles = Title.all
    @genders = Patient.genders
  end


  def edit
  	@titles = Title.all
    @genders = Patient.genders
  end


  def create
    @patient = Patient.new(patient_params)
     authorize @patient
    @error = @patient.error.full_messages.to_sentence unless @patient.save!
  end

  def update
    @patient.attributes = patient_params
    authorize @patient
    @error = @patient.error.full_messages.to_sentence unless @patient.save!
  end


  def destroy
    authorize @patient
   @error = @patient.error.full_messages.to_sentence unless @patient.destroy!
  end

  private
    def set_patient
      @patient = Patient.find(params[:id])
    end


    def patient_params
      params.require(:patient).permit(:title_id, :surname,:firstname, :gender, :age, :hospital_number, :mobile,:nok_name,:nok_mobile)
    end
end
