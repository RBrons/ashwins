class PeopleAndFirm < ApplicationRecord
    attr_accessor :temp_id

    def gen_temp_id
        if !self.entity_id.nil? && self.contact_id.nil?
            self.temp_id = "e#{self.entity_id}"
        elsif self.entity_id.nil? && !self.contact_id.nil?
            self.temp_id = "c#{self.contact_id}"
        else
            self.temp_id = nil
        end
    end

    def use_temp_id
        if self.temp_id.nil?
            return nil
        else
            type_ = self.temp_id[0]
            tid_ =  self.temp_id
            tid_[0] = ''
            tid_ = tid_.to_i
            obj = nil
            if type_ == "c"
                self.contact_id = tid_
                self.entity_id = nil
                self.member_type_id = nil
                obj = Contact.where(id: tid_).first
            elsif type_ == "e"
                self.entity_id = tid_
                self.contact_id = nil
                obj = Entity.where(id: tid_).first
                self.member_type_id = obj.type_
            else 
                return nil
            end
            self.first_name = obj.try(:first_name) || obj.try(:name) 
            self.last_name = obj.last_name
            self.email = obj.email
            self.phone1 = obj.phone1
            self.phone2 = obj.phone2
            self.ein_or_ssn = obj.ein_or_ssn
            self.city = obj.city
            self.state = obj.state
            self.zip = obj.zip
        end
    end

end