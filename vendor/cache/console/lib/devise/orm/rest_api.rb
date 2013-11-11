require "#{Console::Engine.root}/app/models/rest_api"
require 'orm_adapter/adapters/rest_api'

module RestApi
  module Validations
    class UniquenessValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        raise NotImplementedError, "Subclasses must implement a validate_each(record, attribute, value) method"
      end
    end

    module ClassMethods
      def validates_uniqueness_of(*attr_names)
        validates_with UniquenessValidator, _merge_attributes(attr_names)
      end
    end
  end
end

module RestApi
  class Base
    extend ::OrmAdapter::ToAdapter
    self::OrmAdapter = ::OrmAdapter::RestApi

    include RestApi::Validations
    extend RestApi::Validations::ClassMethods

    include ActiveModel::Validations::Callbacks

    extend ActiveModel::Callbacks
    define_model_callbacks :create, :update, :only => [:before, :after]

    extend Devise::Models

    # Seems the devise needs the model have this method
    def [](attr)
      send(attr)
    end
  end
end
