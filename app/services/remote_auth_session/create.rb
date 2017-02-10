class RemoteAuthSession
  class Create < ApplicationService
    include Model
    include Sanitize
    include Validation

    model User, :find

    sanitize do
      required(:user_agent, :string).filled
      required(:remote_ip, :string).filled
      required(:remote_user, User::Types::EMAIL).filled(format?: User::Types::EMAIL_REGEXP)
      required(:name, :string).filled
    end

    validation do
      required(:user_agent, :string).filled
      required(:remote_ip, :string).filled
      required(:remote_user, User::Types::EMAIL).filled(format?: User::Types::EMAIL_REGEXP)
      required(:name, :string).filled

      # We activated new accounts, but have to check existing accounts
      validate active?: [:email] do
        model.active?
      end
    end

    def perform
      validate do
        model.last_login_at = DateTime.current
        model.last_client_info = login_info
        model.regenerate_session_token # Saves the user record
      end
    end

    def find_model!
      user = User.find_or_initialize_by(email: params[:remote_user]) do |u|
        u.name = params[:name]
        # adding a random password since the user model requires a password
        u.password = u.password_confirmation = SecureRandom.base64(12)
        # Bypassing state machine activation actions and marking user as active
        u.state = 'active'
      end

      unless user.persisted?
        user.save!
        UserMailer.welcome(user).deliver_later
      end

      user
    rescue => e
      raise Goby::Exceptions::ValidationErrors.new data: { attributes: ['Could not authenticate user'] }
    end

    def login_info
      "#{params[:remote_ip]} #{params[:user_agent]}"
    end
  end
end
