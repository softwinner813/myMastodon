# frozen_string_literal: true

class Auth::ConfirmationsController < Devise::ConfirmationsController
  layout 'auth'

  before_action :set_body_classes
  before_action :require_unconfirmed!

  skip_before_action :require_functional!

  def new
    super

    resource.email = current_user.unconfirmed_email || current_user.email if user_signed_in?
  end

  private

  def require_unconfirmed!
   
    if user_signed_in? && current_user.confirmed? && current_user.unconfirmed_email.blank?
      redirect_to(current_user.approved? ? root_path : edit_user_registration_path)
    end
  end

  def set_body_classes
    

    @body_classes = 'lighter'
  end

  def after_resending_confirmation_instructions_path_for(_resource_name)
    

    if user_signed_in?
      if current_user.confirmed? && current_user.approved?
        edit_user_registration_path
      else
        auth_setup_path
      end
    else
      new_user_session_path
    end
  end

  def after_confirmation_path_for(_resource_name, user)
    
    print ">>>>>>>>>>>>>>>>>>>>>>>  Redirect after Confirming Email >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    print ENV['REDIRECT_URL']
    # '/' + ENV['REDIRECT_URL']


    ######################################################################################
    # @Auth: SoftWinner
    # @Date: 2021.5.26
    # @Desc: Redirect to other url using ENV variable after confirming email 
    ######################################################################################
    
    # If full redirect to out of mastodon's domain?
    if ENV['IS_FULL_REDIRECT'] && ENV['IS_FULL_REDIRECT'] == 'true' 
      '/foobar/test'
    else
      if ENV['REDIRECT_URL'] && ENV['REDIRECT_URL'] != '' # if exist user's redirect url
        ENV['REDIRECT_URL']
      else 
        if user.created_by_application && truthy_param?(:redirect_to_app)
          user.created_by_application.redirect_uri
        else
          super
        end
      end
    end
  end
end

     
 
