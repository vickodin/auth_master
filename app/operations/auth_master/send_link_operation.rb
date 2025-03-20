module AuthMaster
  class SendLinkOperation
    def self.call!(email, target_scoped_class:)
      target = target_scoped_class.find_by(email:)
      return if target.blank?

      auth_master_session = AuthMaster::SessionService.create!(target)
      AuthMaster::SessionService.send_link!(auth_master_session) if auth_master_session.present?
    end
  end
end