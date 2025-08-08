module ActsAsActive
  class Railtie < Rails::Railtie
    initializer "acts_as_active.configure_rails_initialization" do
      ActiveSupport.on_load(:active_record) do
        require "acts_as_active/activable"
        ActiveRecord::Base.include ActsAsActive
      end
    end

    generators do
      require_relative "../generators/acts_as_active/install_generator"
    end
  end
end