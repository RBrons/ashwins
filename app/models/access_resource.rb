class AccessResource < ApplicationRecord

  def permission_type_
    if permission_type == 1
      return 'Read'
    elsif permission_type == 2
      return 'Write'
    elsif permission_type == 3
      return 'Admin'
    end
  end

  class << self

    # @param [Hash] options
    def can_access?(options = {})
      raise "ArgumentError: #{'User can not blank' if options[:user].blank?} #{'Resource can not blank' if options[:resource].blank?}" if options[:user].blank? || options[:resource].blank?
      resource_klass_to_s = options[:resource].class.to_s
      object = AccessResource.where(user_id: options[:user].id, resource_id: options[:resource].id, resource_klass: resource_klass_to_s).take
      object.try(:can_access) ? object.permission_type : false
    end

    # @param [Hash] options
    def add_access(options = {})
      raise "ArgumentError: #{'User can not blank' if options[:user].blank?} #{'Resource can not blank' if options[:resource].blank?}" if options[:user].blank? || options[:resource].blank?
      resource_klass_to_s = options[:resource].class.to_s
      object = AccessResource.find_or_create_by(user_id: options[:user].id, resource_id: options[:resource].id, resource_klass: resource_klass_to_s)
      object.update_columns(permission_type: (options[:permission_type] || 1), can_access: true)
    end

    # @param [Hash] options
    def remove_access(options = {})
      raise "ArgumentError: #{'User can not blank' if options[:user].blank?} #{'Resource can not blank' if options[:resource].blank?}" if options[:user].blank? || options[:resource].blank?
      resource_klass_to_s = options[:resource].class.to_s
      object = AccessResource.find_or_create_by(user_id: options[:user].id, resource_id: options[:resource].id, resource_klass: resource_klass_to_s)
      object.update_columns(permission_type: 0, can_access: false)
    end

    # @param [Hash] options
    def get_ids(options = {})
      raise "ArgumentError: #{'User can not blank' if options[:user].blank?} #{'Resource class can not blank' if options[:resource_klass].blank?}" if options[:user].blank? || options[:resource_klass].blank?
      AccessResource.where(user_id: options[:user].id, resource_klass: options[:resource_klass]).pluck(:resource_id)
    end

    # @param [Hash] options
    def super_user?(options = {})
      raise "ArgumentError: #{'User can not blank' if options[:user].blank?} #{'Resource class can not blank' if options[:resource_klass].blank?}" if options[:user].blank? || options[:resource_klass].blank?
      AccessResource.where(user_id: options[:user].id, resource_klass: options[:resource_klass]).order(id: :asc).take.try(:user_id) == options[:user].id
    end

  end

end
