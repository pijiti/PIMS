class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def filter
    @patients = Patient.all
    first_name = params[:patient][:firstname]
    surname = params[:patient][:surname]
    mobile = params[:patient][:mobile]
    hospital_number = params[:patient][:hospital_number]

    @patients = @patients.where(:firstname => first_name) if !first_name.blank?
    @patients = @patients.where(:surname => surname) if !surname.blank?
    @patients = @patients.where(:mobile => mobile) if !mobile.blank?
    @patients = @patients.where(:hospital_number => hospital_number) if !hospital_number.blank?

  end

  def index
    #@patients = Patient.all
    @patient_filter = Patient.new
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
    #authorize @patient
    if @patient.save
      flash[:notice] = "Patient record created successfully"
      redirect_to patients_path
    else
      #@error = @patient.error.full_messages.to_sentence
      @error = @patient.errors.full_messages
      flash[:error] = "#{@error.to_sentence}"
      @patients = Patient.all
      @patient_filter = Patient.new
      render "patients/index"
    end

  end

  def update
    @patient.attributes = patient_params
    if @patient.save
      flash[:notice] = "Patient record updated successfully"
      redirect_to patients_path
    else
      @error = @patient.errors.full_messages
      flash[:error] = "#{@error.to_sentence}"
      @titles = Title.all
      @genders = Patient.genders
      render "patients/edit"
    end

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
