class UserMailer < ApplicationMailer
  default from: 'mot-hotspring@example.com'
  
  def creation_email(user)
    @user = user
    mail(
      subject: '登録完了メール',
      to: 'user@example.com',
      )
  end
end
