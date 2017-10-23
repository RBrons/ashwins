module ModelMethods

  def name
    if self.Corporation?
      self.super_entity.try(:name)
    else
      "#{self.first_name} #{self.last_name}"
    end
  end

  def member_type
    Entity.find( self.super_entity_id || self.entity_id ).entity_type
  end

  def Corporation?
    self.member_type.try(:name) == "Corporation"
  end

  def Individual?
    self.member_type.try(:name) == "Individual"
  end

  def LLC?
    self.member_type.try(:name) == "LLC"
  end

  def LLP?
    self.member_type.try(:name) == "LLP"
  end

  def TenancyinCommon?
    self.member_type.try(:name) == "Tenancy in Common"
  end

  def LimitedPartnership?
    self.member_type.try(:name) == "Limited Partnership"
  end

  def Partnership?
    self.member_type.try(:name) == "Partnership"
  end

  def Trust?
    self.member_type.try(:name) == "Trust"
  end

  def JointTenancy?
    self.member_type.try(:name) == "Joint Tenancy with Rights of Survivorship (JTWROS)"
  end

  def TenancyByTheEntirety?
    self.member_type.try(:name) == "Tenancy by the Entirety"
  end

  def power_of_attorney?
    self.member_type.try(:name) == "Power of Attorney"
  end

  def remaining_share_or_interest
    if self.Corporation?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage_stockholder) || 0 )
    elsif self.LLC?
      ( self.super_entity.try(:number_of_assets).try(:to_i) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 )
    elsif self.LLP?
      (self.super_entity.try(:number_of_assets).try(:to_i) || 0)-( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0)
    elsif self.Partnership?
      (self.super_entity.try(:number_of_assets).try(:to_i) || 0)-( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0)
    elsif self.LimitedPartnership?
      ( self.super_entity.try(:number_of_assets).try(:to_i) || 0 ) - (( GeneralPartner.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 ) + ( LimitedPartner.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 ))
    elsif self.TenancyinCommon?
      ( self.super_entity.try(:number_of_assets).try(:to_i) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 )
    elsif self.TenancyByTheEntirety?
      ( self.super_entity.try(:number_of_assets).try(:to_i) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 )
    elsif self.JointTenancy?
      ( self.super_entity.try(:number_of_assets).try(:to_i) || 0 ) - ( JointTenant.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 )
    elsif self.Trust?
      ( self.super_entity.try(:number_of_assets).try(:to_i) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).sum(:my_percentage) || 0 )
    end
  rescue => e
    puts e.message
    puts e.backtrace
    0
  end

  def correct_column
    if self.Corporation?
      :number_of_assets
    elsif self.LLC?
      :number_of_assets
    elsif self.LLP?
      :number_of_assets
    elsif self.TenancyinCommon?
      :number_of_assets
    elsif self.LimitedPartnership?
      :number_of_assets
    end
  end

  def remaining_share_or_interest_
    if self.Corporation?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.LLC?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( Partner.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.LLP?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( Partner.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.Partnership?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.LimitedPartnership?
      ( self.super_entity.try(:number_of_assets) || 0 ) - (( GeneralPartner.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 ) + ( LimitedPartner.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 ))
    elsif self.TenancyinCommon?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.TenancyByTheEntirety?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.JointTenancy?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( JointTenant.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    elsif self.Trust?
      ( self.super_entity.try(:number_of_assets) || 0 ) - ( self.class.where(super_entity_id: self.super_entity_id).where.not(id: self.id).sum(:my_percentage) || 0 )
    end
  rescue => e
    puts e.message
    puts e.backtrace
    0
  end

  def total_remaining_share_or_interest
    ( self.super_entity.try(:number_of_assets) || 0 )
  rescue => e
    puts e.message
    puts e.backtrace
    0
  end

  def remaining_share_or_interest_check
    if remaining_share_or_interest_ < 0
      errors.add(self.correct_column, "Value is Not Good !: value should not Greater than #{remaining_share_or_interest}")
    end
  rescue => e
    puts e.message
    puts e.backtrace
    errors.add(self.correct_column, 'Value is Not Good !')
  end

end
