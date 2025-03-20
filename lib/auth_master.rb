require "auth_master/version"
require "auth_master/engine"

module AuthMaster
  mattr_accessor  :targets, :timing_attack_interval

  def self.configure
    yield self
  end
end
