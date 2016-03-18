class UserMailer < ActionMailer::Base
  # default :from => "pmpstore@sshondopharmacy.com.ng"
  default :from => "\"SSHOndo PIMS\" <pims@sshondopharmacy.com.ng>"

  def approval_alert(user, supply)
    @user = user
    @supply = supply
    @signed_off = User.find_by_id(@supply.signed_off_by).try(:first_name)
    mail(to: user.email, subject: 'New batch of drugs - Awaiting Approval')
  end

  def approval_status_change_alert(supply)
    @supply = supply
    @signed_off_user = User.find_by_id(@supply.signed_off_by)
    mail(to: @signed_off_user.email, subject: 'Approval status of drugs')
  end

  def order_from_vendors(p, s, v)
    @pharm = p
    @store = s
    @vendor = v
    mail(to: v.contact_email, subject: "PMP Store, SSH Ondo")
  end

  def order_from_central_store(u, q, d, s, b, order = nil)
    @qty = q
    @pharm = d
    @store = s
    @user = u
    @brand = b
    @order = order
    mail(to: u.email, subject: "Restocking of drugs request from #{s.name}")
  end

  def send_test_mail
    # delivery_options = { user_name: "pmpstore@sshondopharmacy.com.ng",
    #                      password: "omega3/6",
    #                      address: 'smtp.zoho.com' ,
    #                      port: 587,
    #                      :authentication       => :login
    # }
    mail(from: "pmpstore@sshondopharmacy.com.ng", to: "vigneshp.ceg@gmail.com", subject: 'test mail')
  end


end
