module MyFunction
  
  def access_resource
    AccessResource.find_or_create_by(resource_id: self.id, resource_klass: self.class.to_s, user_id: self.user_id)
  end
  
  def add_key
    if self.class.column_names.include? "key"
      if self.key.blank?
        self.update_column(:key, Key.unused_key)
      end
    end
  end
  
  def delete
    if self.class.column_names.include? "deleted"
      self.update_column(:deleted, true)
    else
      super
    end
  end
  
  def destroy
    if self.class.column_names.include? "deleted"
      self.update_column(:deleted, true)
    else
      super
    end
  end
  
  def destroy!
    if self.class.column_names.include? "deleted"
      self.update_column(:deleted, true)
    else
      super
    end
  end
  
  def phone_validation
    if self.phone1.present?
      begin
        local_phone1 = Phoner::Phone.parse(self.phone1)
        if local_phone1.number.blank?
          raise StandardError
        end
      rescue => e
        puts e.message
        puts e.backtrace
        errors.add(:phone1, " enter correct format. example: +(country code) (phone number)")
      end
    end
    
    if self.phone1.present?
      begin
        local_phone2 = Phoner::Phone.parse(self.phone2)
        if local_phone2.number.blank?
          raise StandardError
        end
      rescue => e
        puts e.message
        puts e.backtrace
        errors.add(:phone2, " enter correct format. example: +(country code) (phone number)")
      end
    end
  end
  
  def Corporation?
    self.entity_type.try(:name) == "Corporation"
  end
  
  def Individual?
    self.entity_type.try(:name) == "Individual"
  end
  
  def LLC?
    self.entity_type.try(:name) == "LLC"
  end
  
  def LLP?
    self.entity_type.try(:name) == "LLP"
  end
  
  def TenancyinCommon?
    self.entity_type.try(:name) == "Tenancy in Common"
  end
  
  def LimitedPartnership?
    self.entity_type.try(:name) == "Limited Partnership"
  end
  
  def Partnership?
    self.entity_type.try(:name) == "Partnership"
  end
  
  def SoleProprietorship?
    self.entity_type.try(:name) == "Sole Proprietorship"
  end
  
  def Estate?
    self.entity_type.try(:name) == "Estate"
  end
  
  def Trust?
    self.entity_type.try(:name) == "Trust"
  end
  
  def Guardianship?
    self.entity_type.try(:name) == "Guardianship"
  end
  
  def JointTenancy?
    self.entity_type.try(:name) == "Joint Tenancy with Rights of Survivorship (JTWROS)"
  end
  
  def TenancyByTheEntirety?
    self.entity_type.try(:name) == "Tenancy by the Entirety"
  end
  
  def power_of_attorney?
    self.entity_type.try(:name) == "Power of Attorney"
  end
  
  def check_uniqueness
    __false__ = true
    if self.respond_to?(:errors) && self.errors.blank? && self.respond_to?(:class) && self.class.respond_to?(:column_names) && self.class.table_name == 'entities'
      column_names   = self.class.column_names - ['id', 'created_at', 'updated_at', 'key']
      condition_hash = {}
      column_names.each do |column_name|
        if self[column_name.to_sym].present?
          condition_hash[column_name.to_sym] = self[column_name.to_sym]
        end
      
      end
      
      if self.class.where.not(id: self.id).where(condition_hash).first
        __false__ = false
        self.errors.add(:base, 'Seems Duplicate Record !')
      end
    
    end
    __false__
  end
  
  def valid_date_of_formation
    if self.respond_to?(:class) && self.class.table_name == 'entities'
      if self.date_of_formation.present? && self.date_of_formation > Time.zone.now
        self.errors.add(:date_of_formation, 'Can not be Future Date !')
        return false
      end
    end
  end

end
