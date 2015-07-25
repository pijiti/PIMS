class UserMailer < ActionMailer::Base
  default :from => "\"Auto Attend\" <admin@autoattend.com>"

  def approval_alert(user , supply)
    @user = user
    @supply = supply
    @signed_off = User.find_by_id(@supply.signed_off_by).try(:first_name)
    mail(to: user.email, subject: 'New batch of drugs - Awaiting Approval')
  end


end
