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

  def switch_xs
    "btn btn-default btn-xs btn-primary buttons-margin"
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
        entity.partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      # when "Sole Proprietorship"
      #   [[entity.full_name, '#']]
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

  def options_html(type, is_person, super_entity, cid="00", return_type="html")
    sel_flag = true
    sel_str = ""

    poa_str = " (Principal Entity) "
    poa_str = " (Principal Individual) " if is_person == "true"

    array_result = []
    select_one_html = "<option>Select One...</option>"
    result = ""

    if is_person == "true"
      groups = {}

      case type
      when "stockholder"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "principal"
        person_true_entities = current_user.entities_list(super_entity).where(type_: [1, 2, 4]).order(type_: :asc)
      when "agent"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2]).where('id != ?', super_entity.principal.entity_id).order(type_: :asc)
      when "settlor"
        person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
      when "trustee"
        if super_entity.beneficiaries.select(:entity_id).map(&:entity_id).blank?
          person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3, 4]).order(type_: :asc)
        else
          person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 3, 4]).where('id not in (?)', super_entity.beneficiaries.select(:entity_id).map(&:entity_id)).order(type_: :asc)
        end
      when "beneficiary"
        if super_entity.trustees.select(:entity_id).map(&:entity_id).blank?
          person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).order(type_: :asc)
        else
          person_true_entities = current_user.entities_list(super_entity.id).where(type_: [1, 2, 3, 4]).where('id not in (?)', super_entity.trustees.select(:entity_id).map(&:entity_id)).order(type_: :asc)
        end
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

      case type
      when "stockholder"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Corporate Stockholder', user_id: current_user.id)
      when "principal"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Principal', user_id: current_user.id)
      when "agent"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Agent', user_id: current_user.id)
      when "settlor"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Settlor', user_id: current_user.id)
      when "trustee"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Trustee', user_id: current_user.id)
      when "beneficiary"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Beneficiary', user_id: current_user.id)
      when "member"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LLC Member', user_id: current_user.id)
      when "manager"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LLC Outside Manager', user_id: current_user.id)
      when "general-partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LP General Partner', user_id: current_user.id)
      when "limited-partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'LP Limited Partner', user_id: current_user.id)
      when "partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Partner', user_id: current_user.id)
      when "limited-liability-partner"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Limited Liability Partner', user_id: current_user.id)
      when "director"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Corporate Director', user_id: current_user.id)
      when "officer"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Corporate Officer', user_id: current_user.id)
      when "tenant-in-common"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Tenant in Common', user_id: current_user.id)
      when "spouse"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Tenant by Entirety', user_id: current_user.id)
      when "joint-tenant"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Joint Tenant', user_id: current_user.id)
      when "judge"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Judge', user_id: current_user.id)
      when "guardian"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Guardian', user_id: current_user.id)
      when "ward"
        person_true_contacts = Contact.all.where(is_company: false, contact_type: 'Client Participant', role: 'Ward', user_id: current_user.id)
      else
        person_true_contacts = []
      end

      groups.each do |k,v|
        result += "<optgroup label='#{k}'>"
        v.each do |entity|
          if (sel_flag && "e#{entity.id}" == cid) || (person_true_entities.count + person_true_contacts.count == 1)
            sel_flag = false
            sel_str = " selected='selected' "
          else
            sel_str = ""
          end
          result += "<option value='e#{entity.id}' data-type='entity' #{sel_str}>#{entity.name} </option>"
          array_result << [entity.id, entity.name]
        end
        result += "</optgroup>"
      end

      result += "<optgroup label='Contacts'>"

      person_true_contacts.each do |contact|
        if (sel_flag && "c#{contact.id}" == cid) || (person_true_entities.count + person_true_contacts.count == 1)
          sel_flag = false
          sel_str = " selected='selected' "
        else
          sel_str = ""
        end
        result += "<option value='c#{contact.id}' data-type='contact' #{sel_str}>#{contact.name}</option>"
        array_result << [contact.id, contact.name]
      end

      result += "</optgroup>"
      if return_type == 'html'
        if array_result.length > 1
          return (select_one_html + result).html_safe
        else
          return result.html_safe
        end
      else
        return array_result
      end

    else
      groups = {}

      case type
      when "stockholder"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [6, 10, 11, 12, 13, 14]).order(type_: :asc)
      when "principal"
        person_false_entities = current_user.entities_list(super_entity).where(type_: [6, 10, 11, 12, 13, 14]).order(type_: :asc)
      when "agent"
        person_false_entities = current_user.entities_list(super_entity.id).where(type_: [10, 11, 12, 13, 14]).where('id != ?', super_entity.principal.entity_id).order(type_: :asc)
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

      case type
      when "stockholder"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Corporate Stockholder', user_id: current_user.id)
      when "principal"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Principal', user_id: current_user.id)
      when "agent"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Agent', user_id: current_user.id)
      when "trustee"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Trustee', user_id: current_user.id)
      when "member"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LLC Member', user_id: current_user.id)
      when "manager"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LLC Outside Manager', user_id: current_user.id)
      when "general-partner"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LP General Partner', user_id: current_user.id)
      when "limited-partner"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'LP Limited Partner', user_id: current_user.id)
      when "tenant-in-common"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Tenant in Common', user_id: current_user.id)
      when "judge"
        person_false_contacts = Contact.all.where(is_company: true, contact_type: 'Client Participant', role: 'Judge', user_id: current_user.id)
      else
        person_false_contacts = []
      end

      groups.each do |k,v|
        result += "<optgroup label='#{k}'>"
        v.each do |entity|
          if (sel_flag && "e#{entity.id}" == cid) || (person_false_entities.count + person_false_contacts.count == 1)
            sel_flag = false
            sel_str = " selected='selected' "
          else
            sel_str = ""
          end
          result += "<option value='e#{entity.id}' data-type='entity' #{sel_str}>#{entity.name} </option>"
          array_result << [entity.id, entity.name]
        end
        result += "</optgroup>"
      end

      result += "</optgroup><optgroup label='Contacts '>"

      person_false_contacts.each do |contact|
        if (sel_flag && "c#{contact.id}" == cid) || (person_false_entities.count + person_false_contacts.count == 1)
          sel_flag = false
          sel_str = " selected='selected' "
        else
          sel_str = ""
        end
        result += "<option value='c#{contact.id}' data-type='contact' #{sel_str}>#{contact.name}</option>"
        array_result << [contact.id, contact.name]
      end

      result += "</optgroup>"
      if return_type == 'html'
        if array_result.length > 1
          return (select_one_html + result).html_safe
        else
          return result.html_safe
        end
      else
        return array_result
      end

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

  def options_html_entities(sel_id, type_, sub_type_="entity", return_type="html")
    object_array = []
    poa_str = " (Principal Individual) "
    poa_str = " (Principal Entity) " if sub_type_ == "entity"
    if type_ == "transactions"
      object_array = Entity.where(user_id: current_user.id).TransactionEntityWithType(sub_type_)
    elsif type_ == "properties"
      object_array = Entity.where(user_id: current_user.id).PurchasedPropertyEntityWithType(sub_type_)
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
    html_result = "<option>Select One...</option>"
    array_result = []
    selflag = true
    groups.each do |k, v|
      html_result += "<optgroup label='#{k}'>"
      v.each do |entity|
        if selflag && sel_id == entity[1]
          html_result += "<option value=#{entity[1]} data-type='entity' selected='selected'>#{entity[0]}</option>"
          selflag = false
        else
          html_result += "<option value=#{entity[1]} data-type='entity'>#{entity[0]}</option>"
        end

        array_result << [entity[0], entity[1]]
      end
      html_result += "</optgroup>"
    end
    if return_type == 'html'
      return html_result.html_safe
    else
      return array_result
    end
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

  def flash_class(level, hideType="normal_hide")
    case level
      when "notice" then "flash-message alert alert-info #{hideType}"
      when "success" then "flash-message alert alert-success #{hideType}"
      when "error" then "flash-message alert alert-error #{hideType}"
      when "alert" then "flash-message alert alert-error #{hideType}"
    end
  end

  def property_comments_html(comments)
    result = "<div class='comments-wrapper'>"

    comments.each do |comment|
      result += "<div class='comment'>"
      result += "<div class='comment-info clearfix'>"
      result += "<span class='pull-right'>Commented by <b>#{comment.user.name}</b> at <b>#{comment.created_at}</b></span>"
      result += "</div>"
      result += "<div class='comment-content'>#{comment.comment}</div>"
      result += "</div>"
    end
    result += "</div>"

    return result.html_safe
  end

  def property_owned_by(property)
    e = Entity.where(property_id: property)

    if e.present?
      if (e.first.type_ == 7)
        result = "Tenancy in Common -- "

        if e.first.tenants_in_common.length == 0
          result += "Unspecified"
        else
          e.first.tenants_in_common.each do |t|
            result += "#{t.name} "
          end
        end
      elsif (e.first.type_ == 8)
        result = "Joint Tenancy -- "

        if e.first.joint_tenants.length == 0
          result += "Unspecified"
        else
          e.first.joint_tenants.each do |t|
            result += "#{t.name} "
          end
        end
      elsif (e.first.type_ == 9)
        result = "Tenancy by the Entirety -- "

        if e.first.spouses.length == 0
          result += "Unspecified"
        else
          e.first.spouses.each do |t|
            result += "#{t.name} "
          end
        end
      else
        # Not sure case
        return ""
      end
    else
      return ""
    end

    return result
  end

  def clients_delete_warning_message(entity)
    result = ""
    listA = []

    case entity.entity_type.try(:name)
      when "LLC"
        listA = entity.members.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } + entity.managers.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "LLP"
        listA = entity.partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Power of Attorney"
        listA = entity.agents.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      # when "Guardianship"
      #   [[entity.full_name, '#']]
      when "Trust"
        listA = entity.beneficiaries.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } + entity.trustees.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } + entity.settlors.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        listA = entity.joint_tenants.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Limited Partnership"
        listA = entity.general_partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } +
          entity.limited_partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Tenancy in Common"
        listA = entity.tenants_in_common.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Corporation"
        listA = entity.stockholders.map { |m| ["#{m.name} - #{m.my_percentage_stockholder}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } + entity.directors.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] } + entity.officers.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Partnership"
        listA = entity.partners.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Tenancy by the Entirety"
        listA = entity.spouses.map { |m| ["#{m.name}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      else
        # No need to handle
    end

    if listA.length > 0
      result = "<p>One or more Clients or Contacts have one or more interests or fiduciary or donor relationship(s) in or to <b>#{entity.display_name}</b>.</p>"
      result += "<ul>"

      listA.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]}</a></li>"
      end
      result += "</ul>"
    end

    listB = []

    if m = Member.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Manager.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = LimitedPartner.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Beneficiary.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Trustee.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Settlor.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = GeneralPartner.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = StockHolder.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage_stockholder}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Officer.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Director.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Partner.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Principal.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Agent.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = TenantInCommon.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = JointTenant.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Spouse.find_by_entity_id(entity.id)
      e = m.super_entity
      listB.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if listB.length > 0
      result += "<p><b>#{entity.display_name}</b> has one or more ownership or beneficial interest(s) or fiduciary or donor relationship(s) in or to the following entitie(s).</p>"
      result += "<ul>"

      listB.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]} (#{l[2]})</a></li>"
      end
      result += "</ul>"
    end

    listC = []
    if [7, 8, 9].include? entity.type_
      listC.push [ entity.property.street_address_with_suffix, edit_property_path(entity.property.key), "Property", 0] unless entity.property.nil?
    else
      Property.where(owner_entity_id: entity.id, :ownership_status => 'Purchased').each do |p|
        listC.push [ p.title, edit_property_path(p.key), "Property", 0]
      end
    end

    if listC.length > 0
      result += "<p><b>#{entity.display_name}</b> has one or more ownership interest in the following Properties.</p>"
      result += "<ul>"

      listC.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]} (#{l[2]})</a></li>"
      end
      result += "</ul>"
    end

    listD = []

    # TransactionSale
    klazz         = 'TransactionSale'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.relinquishing_seller_entity_id == entity.id
        listD.push ['transaction(sale)', edit_transaction_path(t, type: 'sale', main_id: t.main.id)]
      end
    end

    # TransactionPurchase
    klazz         = 'TransactionPurchase'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.replacement_purchaser_entity_id == entity.id
        listD.push ['transaction(purchase)', edit_transaction_path(t, type: 'purchase', main_id: t.main.id)]
      end
    end

    if listD.length > 0
      result += "<p><b>#{entity.display_name}</b> has been involved in the following Transactions.</p>"
      result += "<ul>"

      listD.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]}</a></li>"
      end
      result += "</ul>"
    end

    result += "<p>If you delete this client, the interests and relationships will be deleted and the Transactions will be affected.</p>"

    return result.html_safe
  end

  def contacts_delete_warning_message(contact)
    result = ""
    listA = []

    if m = Member.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Manager.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = LimitedPartner.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Beneficiary.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Trustee.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Settlor.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = GeneralPartner.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = StockHolder.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage_stockholder}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Officer.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Director.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Partner.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Principal.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Agent.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = TenantInCommon.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = JointTenant.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name} - #{m.my_percentage}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if m = Spouse.find_by_contact_id(contact.id)
      e = m.super_entity
      listA.push ["#{e.name}", edit_entity_path(e.key), MemberType.member_types[e.type_], e.id] unless e.nil?
    end

    if listA.length > 0
      result += "<p><b>#{contact.name}</b> has one or more ownership or beneficial interest(s) or fiduciary or donor relationship(s) in or to the following entitie(s).</p>"
      result += "<ul>"

      listA.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]} (#{l[2]})</a></li>"
      end
      result += "</ul>"
    end

    listB = []
    Property.where(:owner_entity_id => contact.id, :ownership_status => 'Prospective Purchase').each do |p|
      listB.push [ p.title, edit_property_path(p.key), "Property", 0]
    end

    if listB.length > 0
      result += "<p><b>#{contact.name}</b> has one or more ownership interest in the following Properties.</p>"
      result += "<ul>"

      listB.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]} (#{l[2]})</a></li>"
      end
      result += "</ul>"
    end

    listC = []
    # TransactionSale
    klazz         = 'TransactionSale'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.relinquishing_purchaser_contact_id == contact.id
        listC.push ['transaction(sale)', edit_transaction_path(t, type: 'sale', main_id: t.main.id)]
      end
    end

    # TransactionPurchase
    klazz         = 'TransactionPurchase'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.replacement_seller_contact_id == contact.id
        listC.push ['transaction(purchase)', edit_transaction_path(t, type: 'purchase', main_id: t.main.id)]
      end
    end

    if listC.length > 0
      result += "<p><b>#{entity.display_name}</b> has been involved in the following Transactions.</p>"
      result += "<ul>"

      listC.each do |l|
        result += "<li><a href='#{l[1]}'>#{l[0]}</a></li>"
      end
      result += "</ul>"
    end

    result += "<p>If you delete this contact, the interests and relationships will be deleted and the Transactions will be affected.</p>"

    return result.html_safe
  end

  def clients_delete(entity)
    # TransactionSale
    klazz         = 'TransactionSale'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.relinquishing_seller_entity_id == entity.id
        t.main.destroy if t.main.present?
      end
    end

    # TransactionPurchase
    klazz         = 'TransactionPurchase'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.replacement_purchaser_entity_id == entity.id
        t.destroy if t.main.present?
      end
    end

    # ICPs
    case entity.entity_type.try(:name)
      when "LLC"
        (entity.members + entity.managers).each do |e|
          e.destroy
        end
      when "LLP"
        entity.partners.each do |e|
          e.destroy
        end
      when "Power of Attorney"
        entity.agents.each do |e|
          e.destroy
        end
      when "Trust"
        (entity.beneficiaries + entity.trustees + entity.settlors).each do |e|
          e.destroy
        end
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        entity.joint_tenants.each do |e|
          e.destroy
        end
      when "Limited Partnership"
        (entity.general_partners + entity.limited_partners).each do |e|
          e.destroy
        end
      when "Tenancy in Common"
        listA = entity.tenants_in_common.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Corporation"
        (entity.stockholders + entity.directors + entity.officers).each do |e|
          e.destroy
        end
      when "Partnership"
        entity.partners.each do |e|
          e.destroy
        end
      when "Tenancy by the Entirety"
        entity.spouses.each do |e|
          e.destroy
        end
      else
        # No need to handle
    end

    if m = Member.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Manager.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = LimitedPartner.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Beneficiary.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Trustee.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Settlor.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = GeneralPartner.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = StockHolder.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Officer.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Director.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Partner.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Principal.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Agent.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = TenantInCommon.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = JointTenant.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Spouse.find_by_entity_id(entity.id)
      m.destroy
    end

    #Properties
    Property.where(owner_entity_id: entity.id, :ownership_status => 'Purchased').each do |p|
      p.update_attributes(:owner_entity_id => 0, :owner_person_is => 0)
    end
  end

  def contacts_delete(contact)

    # TransactionSale
    klazz         = 'TransactionSale'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.relinquishing_purchaser_contact_id == contact.id
        t.main.destroy if t.main.present?
      end
    end

    # TransactionPurchase
    klazz         = 'TransactionPurchase'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.replacement_seller_contact_id == contact.id
        t.main.destroy if t.main.present?
      end
    end

    #ICPs
    if m = Member.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Manager.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = LimitedPartner.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Beneficiary.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Trustee.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Settlor.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = GeneralPartner.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = StockHolder.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Officer.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Director.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Partner.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Principal.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Agent.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = TenantInCommon.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = JointTenant.find_by_contact_id(contact.id)
      m.destroy
    end

    if m = Spouse.find_by_contact_id(contact.id)
      m.destroy
    end

    #Properties
    Property.where(:owner_entity_id => contact.id, :ownership_status => 'Prospective Purchase').each do |p|
      p.update_attributes(:owner_entity_id => 0, :owner_person_is => nil)
    end

  end

end
