require 'base64'

module ApplicationHelper

  def extract_emails string
    string.try(:scan, /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)
  end

  def current_FULLPATH
    request.original_fullpath
  end

  def base64_encode t
    Base64.strict_encode64(t)
  end

  def title(page_title = '1031 Exchange', options={})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options)
  end

  def image_via_mimetype(mimetype)
    if mimetype.include?('pdf')
      'pdf.png'
    elsif mimetype.include?('doc')
      'doc.png'
    elsif mimetype.include?('docx')
      'docx.png';
    elsif mimetype.include?('wpd')
      'wpd.png';
    elsif mimetype.include?('xls')
      'xls.png';
    elsif mimetype.include?('ppt')
      'ppt.png';
    elsif mimetype.include?('image')
      'image-file.png'
    else
      'other.png'
    end
  end

  def xs_default
    "btn btn-default btn-xs buttons-margin"
  end

  def show_xs
    "btn btn-default btn-xs btn-primary buttons-margin"
  end

  def edit_xs
    "btn btn-default btn-xs btn-warning buttons-margin"
  end

  def delete_xs
    "btn btn-default btn-xs btn-danger buttons-margin"
  end

  def sumup_values val1, val2
    (val1 || 0) + (val2 || 0) rescue 0
  end

  def minp_values val1, val2
    (val1 || 0) - (val2 || 0) rescue 0
  end

  def override_active_record_errors(errors_hash, replace_keys = {})
    keys_with_order, new_h, messages = errors_hash.keys, {}, []
    replace_keys.each do |old_key, new_key|
      if keys_with_order.include? old_key
        errors_hash[new_key] = errors_hash.delete(old_key)
        keys_with_order.collect! { |k|
          if k == old_key
            k = new_key
          else
            k = k
          end
        }
      end
    end
    keys_with_order.each { |k| new_h[k] = errors_hash[k] }
    new_h.each { |k, v|
      if k.class == Symbol
        messages << "#{k.to_s.humanize.strip} #{v[0].to_s.strip}"
      else
        messages << "#{k.to_s.gsub("_", " ").strip} #{v[0].to_s.strip}"
      end
    }
    messages
  end

  def require_field
    '<span style="color: red; padding-left: 5px">*</span>'.html_safe
  end

  def remove_from_errors
    []
  end

  def transaction_message_filter(message)
    if message.include?('Purchase only closing date ')
      message.gsub('Purchase only closing date ', '')
    elsif message.include?('Purchase only qi funds ')
      message.gsub('Purchase only qi funds ', '')
    elsif message.include?('Purchaser entity ')
      message.gsub('Purchaser entity ', '')
    elsif message.include?('Seller entity ')
      message.gsub('Seller entity ', '')
    elsif message.include?('Seller first name Relinquishing ')
      message.sub('Seller first name ', '')
    elsif message.include?('Seller last name Relinquishing ')
      message.sub('Seller last name ', '')
    elsif message.include?('Purchaser first name Relinquishing ')
      message.sub('Purchaser first name ', '')
    elsif message.include?('Purchaser last name Relinquishing ')
      message.sub('Purchaser last name ', '')
    elsif message.include?('Seller first name Replacement ')
      message.sub('Seller first name ', '')
    elsif message.include?('Seller last name Replacement ')
      message.sub('Seller last name ', '')
    elsif message.include?('Purchaser first name Replacement ')
      message.sub('Purchaser first name ', '')
    elsif message.include?('Purchaser last name Replacement ')
      message.sub('Purchaser last name ', '')
    else
      message
    end
  end

  def gsub_error_message(message, gsubs=[])
    done = false
    until done do
      done = true if gsubs.blank?
      gsubs.each do |g|
        if message.include?(g)
          message.gsub!(g, '')
          done = true
        end
      end
    end
    message
  end

  def modify_query(url, options={})
    uri        = URI(url)
    query_hash = Rack::Utils.parse_query(uri.query)
    query_hash.merge!(options.stringify_keys)
    uri.query = Rack::Utils.build_query(query_hash)
    uri.to_s
  end

  def display_standard_table(resource_klass, collection = {}, options={})

    columns = (resource_klass.view_index_columns.collect { |t| t[:show] }.flatten + ['Action'])

    thead = content_tag :thead do
      content_tag :tr do
        columns.collect { |column| content_tag(:th, column) }.join().html_safe
      end
    end

    tbody = content_tag :tbody do
      collection.collect { |elem|
        content_tag :tr do
          (resource_klass.view_index_columns.collect { |column|
            content_tag(:td, (column[:eval] ? eval(column[:eval]) : elem.send(column[:call])))
          } + [content_tag(:td, (link_to 'Delete', elem.delete_url, class: 'btn btn-sm btn-danger margin-sm-left', method: :delete, data: { confirm: 'Are you sure ?' }))
          ]).join().html_safe
        end
      }.join().html_safe
    end

    content_tag :table, id: options[:table_id] do
      thead.concat(tbody)
    end
  end

  def owned_by(entity)
    case entity.entity_type.try(:name)
      when "LLC"
        entity.members.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "LLP"
        entity.limited_partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Sole Proprietorship"
        [[entity.full_name, '#']]
      when "Power of Attorney"
        entity.agents.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Guardianship"
        [[entity.full_name, '#']]
      when "Trust"
        entity.beneficiaries.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } +
          entity.trustees.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        entity.joint_tenants.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Limited Partnership"
        entity.general_partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } +
          entity.limited_partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Tenancy in Common"
        entity.tenants_in_common.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Corporation"
        entity.stockholders.map { |m| ["#{m.name} - #{m.my_percentage_stockholder}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Partnership"
        entity.partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Tenancy by the Entirety"
        entity.spouses.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      else
        [["", "#"]]
    end
  end

  def owns(entity)
    result = []

    if m = Member.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = LimitedPartner.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Beneficiary.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Trustee.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = GeneralPartner.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = StockHolder.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage_stockholder}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Partner.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Principal.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Agent.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = TenantInCommon.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = JointTenant.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Spouse.find_by_entity_id(entity.id)
      e = m.super_entity
      result.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if [7, 8, 9].include? entity.type_
      result.push [ entity.property.street_address_with_suffix, edit_property_path(entity.property.key), "Property", 0] unless entity.property.nil?
    else
      Property.where(owner_entity_id: entity.id).each do |p|
        result.push [ p.title, edit_property_path(p.key), "Property", 0]
      end
    end

    return result
  end

  def first_name_of_entity(entity)
    case entity.entity_type.try(:name)
      when "LLC"
        entity.first_name
      when "LLP"
        entity.first_name
      when "Sole Proprietorship"
        entity.first_name
      when "Power of Attorney"
        entity.first_name2
      when "Guardianship"
        entity.guardian_first_name
      when "Trust"
        entity.first_name
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        ""
      when "Limited Partnership"
        entity.first_name
      when "Tenancy in Common"
        ""
      when "Corporation"
        entity.first_name
      when "Partnership"
        entity.first_name
      when "Tenancy by the Entirety"
        ""
      when "Individual"
        entity.first_name
      else
        ""
    end
  end

  def last_name_of_entity(entity)
    case entity.entity_type.try(:name)
      when "LLC"
        entity.last_name
      when "LLP"
        entity.last_name
      when "Sole Proprietorship"
        entity.last_name
      when "Power of Attorney"
        entity.last_name2
      when "Guardianship"
        entity.guardian_last_name
      when "Trust"
        entity.last_name
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        ""
      when "Limited Partnership"
        entity.last_name
      when "Tenancy in Common"
        ""
      when "Corporation"
        entity.last_name
      when "Partnership"
        entity.last_name
      when "Tenancy by the Entirety"
        ""
      when "Individual"
        entity.last_name
      else
        ""
    end
  end

  def client_entity(entity)
    case entity.entity_type.try(:name)
      when "Individual"
        entity.display_name
      when "LLC"
        entity.display_name
      when "LLP"
        entity.display_name
      when "Sole Proprietorship"
        entity.name2
      when "Power of Attorney"
        entity.display_name
      when "Guardianship"
        "In re #{entity.full_name}, AIP"
      when "Trust"
        entity.display_name
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        entity.name
      when "Limited Partnership"
        entity.display_name
      when "Tenancy in Common"
        entity.name
      when "Corporation"
        entity.display_name
      when "Partnership"
        entity.display_name
      when "Tenancy by the Entirety"
        entity.name
      else
        ""
    end
  end

  RULES = {
    "stockholder" => {
      "individual" => {
        "entity_types_allowed" => [1,2,3,4],
        "contact_role_allowed" => "Corporate Stockholder"
      },
      "non-individual" => {
        "entity_types_not_allowed" => [1, 7, 8, 9],
        "contact_role_allowed" => "Corporate Stockholder"
      }
    },
    "officers" => {},
    "directors" => {},
    "beneficiary" => {}
  }

  # Just a reference and ignore this - [1: "Individual", 2: "Sole Proprietorship", 3: "Power of Attorney", 4: "Guardianship", 5: "Estate", 6: "Trust", 7: "Tenancy in Common", 8: "Joint Tenancy with Rights of Survivorship (JTWROS)", 9: "Tenancy by the Entirety", 10: "Partnership", 11: "LLC", 12: "LLP", 13: "Limited Partnership", 14: "Corporation"]

  def options_html(type, is_person, super_entity, cid="00")
    sel_flag = true
    sel_str = ""

    poa_str = " (Principal Entity) "
    poa_str = " (Principal Individual) " if is_person == "true"

    if is_person == "true"
      result = "<option>Select One...</option>"

      groups = {}

      case type
      when "stockholder"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "principal"
        person_true_entities = current_user.entities_list(super_entity).where(type_: [1, 2, 4]).order(type_: :asc)
      when "agent"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2]).order(type_: :asc)
      when "settlor"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "trustee"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3, 4]).order(type_: :asc)
      when "beneficiary"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "member"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "manager"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "general-partner"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "limited-partner"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "partner"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3, 4]).order(type_: :asc)
      when "limited-liability-partner"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3, 4]).order(type_: :asc)
      when "director"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3]).order(type_: :asc)
      when "officer"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3]).order(type_: :asc)
      when "tenant-in-common"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "spouse"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3, 4]).order(type_: :asc)
      when "joint-tenant"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "guardian"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1]).order(type_: :asc)
      when "ward"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1]).order(type_: :asc)
      else
        person_true_entities = []
      end

      person_true_entities.each do |entity|
        key = "#{MemberType.member_types[entity.type_]}"
        key = key + poa_str if !key.match("ttorney").nil?
        if groups[key].nil?
          groups[key] = [entity]
        else
          groups[key] << entity
        end
      end
      groups.each do |k,v|
        result += "<optgroup label='#{k}'>"
        v.each do |entity|
          if sel_flag && "e#{entity.id}" == cid
            sel_flag = false
            sel_str = " selected='selected' "
          else
            sel_str = ""
          end
          result += "<option value='e#{entity.id}' data-type='entity' #{sel_str}>#{entity.name} </option>"
        end
        result += "</optgroup>"
      end

      result += "<optgroup label='Contacts'>"

      case type
      when "stockholder"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Corporate Stockholder')
      when "principal"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Principal')
      when "agent"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Agent')
      when "settlor"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Settlor')
      when "trustee"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Trustee')
      when "beneficiary"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Beneficiary')
      when "member"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LLC Member')
      when "manager"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LLC Outside Manager')
      when "general-partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LP General Partner')
      when "limited-partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LP Limited Partner')
      when "partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Partner')
      when "limited-liability-partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Limited Liability Partner')
      when "director"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Corporate Director')
      when "officer"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Corporate Officer')
      when "tenant-in-common"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Tenant in Common')
      when "spouse"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Tenant by Entirety')
      when "joint-tenant"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Joint Tenant')
      when "judge"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Judge')
      when "guardian"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Guardian')
      when "ward"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Ward')
      else
        person_true_contacts = []
      end

      person_true_contacts.each do |contact|
        if sel_flag && "c#{contact.id}" == cid
          sel_flag = false
          sel_str = " selected='selected' "
        else
          sel_str = ""
        end
        result += "<option value='c#{contact.id}' data-type='contact' #{sel_str}>#{contact.name}</option>"
      end

      result += "</optgroup>"
      return result.html_safe
    else
      result = "<option>Select One...</option>"

      groups = {}

      case type
      when "stockholder"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [6, 10, 11, 12, 13, 14]).order(type_: :asc)
      when "principal"
        person_false_entities = current_user.entities_list(super_entity).where(type_: [6, 10, 11, 12, 13, 14]).order(type_: :asc)
      when "agent"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [10, 11, 12, 13, 14]).order(type_: :asc)
      when "trustee"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [10, 11, 12, 13, 14]).order(type_: :asc)
      when "beneficiary"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [6]).order(type_: :asc)
      when "member"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [6, 10, 11, 12, 13, 14]).order(type_: :asc)
      when "manager"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [10, 11, 12, 13, 14]).order(type_: :asc)
      when "general-partner"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [10, 11, 12, 13, 14]).order(type_: :asc)
      when "limited-partner"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [10, 11, 12, 13, 14]).order(type_: :asc)
      when "tenant-in-common"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [6, 10, 11, 12, 13, 14]).order(type_: :asc)
      when "guardian"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [14]).order(type_: :asc)
      else
        person_false_entities = []
      end

      person_false_entities.each do |entity|
        key = "#{MemberType.member_types[entity.type_]}"
        key = key + poa_str if !key.match("ttorney").nil?
        if groups[key].nil?
          groups[key] = [entity]
        else
          groups[key] << entity
        end
      end
      groups.each do |k,v|
        result += "<optgroup label='#{k}'>"
        v.each do |entity|
          if sel_flag && "e#{entity.id}" == cid
            sel_flag = false
            sel_str = " selected='selected' "
          else
            sel_str = ""
          end
          result += "<option value='e#{entity.id}' data-type='entity' #{sel_str}>#{entity.name} </option>"
        end
        result += "</optgroup>"
      end

      result += "</optgroup><optgroup label='Contacts '>"

      case type
      when "stockholder"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Corporate Stockholder')
      when "principal"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Principal')
      when "agent"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Agent')
      when "trustee"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Trustee')
      when "member"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LLC Member')
      when "manager"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LLC Outside Manager')
      when "general-partner"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LP General Partner')
      when "limited-partner"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LP Limited Partner')
      when "tenant-in-common"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Tenant in Common')
      when "judge"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Judge')
      else
        person_false_contacts = []
      end

      person_false_contacts.each do |contact|
        if sel_flag && "c#{contact.id}" == cid
          sel_flag = false
          sel_str = " selected='selected' "
        else
          sel_str = ""
        end
        result += "<option value='c#{contact.id}' data-type='contact' #{sel_str}>#{contact.name}</option>"
      end

      result += "</optgroup>"
      return result.html_safe
    end
  end

  def linkbacks(temp_id)
    if temp_id.present?
      type_ = temp_id[0]
      temp_id[0] = ''
      id_ = temp_id.to_i

      if type_ == 'c' #contact
        contact_ = Contact.find(id_)
        src_ = edit_contact_path(contact_)
        "<a href='#{src_}' target='_blank' class='linkbacks'>#{contact_.name}</a>".html_safe
      elsif type_ == 'e' #entity
        entity_ = Entity.find(id_)
        src_ = entity_path(entity_)
        "<a href='#{src_}' target='_blank' class='linkbacks'>#{entity_.display_name}</a>".html_safe
      end
    end
  end

  def linkbacks_property(property)
    if property.present?
      src_ = property_path(property.key)
      "<a href='#{src_}' target='_blank' class='linkbacks'>#{property.name}</a>".html_safe
    end
  end

  def linkbacks_entity(entity)
    if !entity.new_record? && entity.present?
      src_ = entity_path(entity)
      "<a href='#{src_}' target='_blank' class='linkbacks'>#{entity.display_name}</a>".html_safe
    end
  end

  def options_html_entities(sel_id, type_, sub_type_="entity")
    object_array = []
    poa_str = " (Principal Individual) "
    poa_str = " (Principal Entity) " if sub_type_ == "entity"
    if type_ == "transactions"
      object_array = Entity.TransactionEntityWithType(sub_type_)
    elsif type_ == "properties"
      object_array = Entity.PurchasedPropertyEntityWithType(sub_type_)
    end
    groups = {}
    object_array.sort_by! {|e| e[2]}
    # item is an 4 tuple - <name>, <id>, <type_>, <type_name>, <suffix_required>
    object_array.each do |item|
      item[3] = 'Joint Tenancy' if item[2] == 8
      key = item[3]
      item[0] = item[0] + " ( " + item[3] + " )" unless item[2] == 1 || !item[4]
      key = key + poa_str if !key.match("ttorney").nil?
      groups[key] = [] if groups[key].nil?
      groups[key] << item
    end
    result = "<option>Select One...</option>"
    selflag = true
    groups.each do |k, v|
      result += "<optgroup label='#{k}'>"
      v.each do |entity|
        if selflag && sel_id == entity[1]
          result += "<option value=#{entity[1]} data-type='entity' selected='selected'>#{entity[0]}</option>"
          selflag = false
        else
          result += "<option value=#{entity[1]} data-type='entity'>#{entity[0]}</option>"
        end
      end
      result += "</optgroup>"
    end
    return result.html_safe
  end

  def options_html_entities_transaction(sel_id, etype="entity")
    entity_array = Entity.TransactionEntityWithType(etype)
    groups = {}
    # item is an entity 4 tuple - <name>, <id>, <type_>, <type_name>
    entity_array.each do |item|
      item[3] = 'Joint Tenancy' if item[2] == 8
      key = item[3]
      groups[key] = [] if groups[key].nil?
      groups[key] << item
    end
    result = "<option>Select One...</option>"
    selflag = true
    groups.each do |k, v|
      result += "<optgroup label='#{k}'>"
      v.each do |entity|
        if selflag && sel_id == entity[1]
          result += "<option value=#{entity[1]} data-type='entity' selected='selected'>#{entity[0]}</option>"
          selflag = false
        else
          result += "<option value=#{entity[1]} data-type='entity'>#{entity[0]}</option>"
        end
      end
      result += "</optgroup>"
    end
    return result.html_safe
  end

  def flash_class(level)
    case level
      when "notice" then "flash-message alert alert-info"
      when "success" then "flash-message alert alert-success"
      when "error" then "flash-message alert alert-error"
      when "alert" then "flash-message alert alert-error"
    end
  end

end
