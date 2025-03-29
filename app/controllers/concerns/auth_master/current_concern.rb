module AuthMaster::CurrentConcern
  extend ActiveSupport::Concern

  # included do
  #   helper_method :current_auth_master
  # end

  def current_auth_master(target_param_name)
    session_accessor_key = [ "current", target_param_name, "id" ].join("_")
    auth_master_session_id = session[session_accessor_key]
    return nil if auth_master_session_id.blank?

    auth_master_session = AuthMaster::Session.active.find_by(id: auth_master_session_id)
    return nil if auth_master_session.blank?

    target = auth_master_session.target
    return nil if target.blank?
    # return nil if !target.is_a?(target_class_by_name(target_param_name))

    target
  end
end
