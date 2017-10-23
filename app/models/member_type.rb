class MemberType < ApplicationRecord

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :members

  cattr_accessor :member_types, :objects, :named_memberids

  def custom_order
    #objects = []
    #["Individual", "Sole Proprietorship", "Power of Attorney", "Guardianship", "Estate", "Trust", "Tenancy in Common",
    # "Joint Tenancy with Rights of Survivorship (JTWROS)", "Tenancy by the Entirety", "Partnership", "LLC", "LLP",
    # "Limited Partnership", "Corporation"].each do |name|
    #  objects << MemberType.find_or_create_by(name: name)
    #end
    self.class.objects
  end

  def self.getCorporationId
    MemberType.named_memberids["Corporation"] 
  end

  def self.getLLCId
    MemberType.named_memberids["LLC"]
  end

  def self.getLLPId
    MemberType.named_memberids["LLP"]
  end

  def self.getPartnershipId
    MemberType.named_memberids["Partnership"]
  end

  def self.getLimitedPartnershipId
    MemberType.named_memberids["Limited Partnership"]
  end

  def self.getSoleProprietorshipId
    MemberType.named_memberids["Sole Proprietorship"]
  end

  def self.getEstateId
    MemberType.named_memberids["Estate"]
  end

  def self.getTrustId
    MemberType.named_memberids["Trust"]
  end

  def self.getGuardianshipId
    MemberType.named_memberids["Guardianship"]
  end

  def self.getTenancyinCommonId
    MemberType.named_memberids["Tenancy in Common"]
  end

  def self.getJointTenancyId
    MemberType.named_memberids["Joint Tenancy with Rights of Survivorship (JTWROS)"]
  end

  def self.getTenancyByTheEntiretyId
    MemberType.named_memberids["Tenancy by the Entirety"]
  end

  def self.getPowerOfAttorneyId
    MemberType.named_memberids["Power of Attorney"]
  end
  
  def self.getIndividualId
    MemberType.named_memberids["Individual"]
  end

  def self.InitMemberTypes
    self.member_types = {}
    self.named_memberids = {}
    self.objects = []
    ["Individual", "Sole Proprietorship", "Power of Attorney", "Guardianship", "Estate", "Trust", "Tenancy in Common",
     "Joint Tenancy with Rights of Survivorship (JTWROS)", "Tenancy by the Entirety", "Partnership", "LLC", "LLP",
     "Limited Partnership", "Corporation"].each do |name|
      object = MemberType.find_or_create_by(name: name)
      self.member_types.store(object.id, object.name)
      self.named_memberids.store(object.name, object.id)
      self.objects << object
    end
  end
  
end
