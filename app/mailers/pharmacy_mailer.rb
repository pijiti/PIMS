class PharmacyMailer < ActionMailer::Base

  def send_test_mail
    mail(from: "pims@sshondopharmacy.com.ng" , to: "vigneshp.ceg@gmail.com", subject: 'test mail')
  end


end
