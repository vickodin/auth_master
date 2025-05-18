module AuthMaster::CurrentConcern
  extend ActiveSupport::Concern

  def auth_master_current(target_param_name)
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

  def auth_master_prepare_token(target, purpose: nil)
    return if target.blank?
    return if !target.persisted?

    uuid = auth_master_session_id_generator
    target_class = target.respond_to?(:auth_master_config_class) ? target.auth_master_config_class : target.class
    session[auth_master_session_key(target_class)] = uuid

    AuthMaster::PrepareTokenOperation.call!(target, uuid:, purpose:)
  end

  def auth_master_login_by_token(target_class, token, purpose: nil)
    uuid = session[auth_master_session_key(target_class)]

    auth_master_session = AuthMaster::LoginByTokenOperation.call!(token, uuid:, target_class:, purpose:)
    return if auth_master_session.blank?

    session.delete(auth_master_session_key(target_class))
    session[auth_master_target_session_key(target_class)] = auth_master_session.id

    auth_master_session.target
  end

  def auth_master_login_as!(target)
    auth_master_session = AuthMaster::LoginOperation.call!(target, uuid: auth_master_session_id_generator)
    session[auth_master_target_session_key(target.class)] = auth_master_session.id

    true
  end

  def auth_master_logout(target_class)
    auth_master_session_id = session.delete(auth_master_target_session_key(target_class))
    AuthMaster::LogoutOperation.call!(auth_master_session_id)
  end

  private

  def auth_master_session_key(target_class)
    [ "auth_master", target_class.name.underscore, "id" ].join("_")
  end

  def auth_master_target_session_key(target_class)
    [ "current", target_class.name.underscore, "id" ].join("_")
  end

  def auth_master_session_id_generator
    Random.uuid
  end
end
