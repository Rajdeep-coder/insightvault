# frozen_string_literal: true

class Layout::NavbarComponent < ViewComponent::Base
    delegate :current_user, :user_signed_in?, :dashboard_path, :destroy_user_session_path, to: :helpers
end
