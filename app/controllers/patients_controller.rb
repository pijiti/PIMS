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
      if @patient.save
       redirect_to patients_path
      else
       render :new
    end
  end

  def update
      if @patient.update(patient_params)
       redirect_to patients_path
      else
       render :edit
    end
  end


  def destroy
    @patient.destroy
     redirect_to patients_path
  end

  private
    def set_patient
      @patient = Patient.find(params[:id])
    end


    def patient_params
      params.require(:patient).permit(:title_id, :patient_surname,:patient_firstname, :gender, :patient_age, :patient_hospital_id, :patient_mobile,:nok_name,:nok_mobile)
    end
end
