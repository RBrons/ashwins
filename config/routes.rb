Rails.application.routes.draw do

  resources :groups
  resources :common_static_fields

  post "/entities/share_or_interest" => "entities#share_or_interest"
  get "/entities/xhr_list" => "entities#xhr_list"
  resources :entities

  namespace :entities do
    # Individuals
    get "individuals/basic_info/(:entity_key)" => "individuals#basic_info", as: :individuals_basic_info
    post "individuals/basic_info/(:entity_key)" => "individuals#basic_info"
    patch "individuals/basic_info/:entity_key" => "individuals#basic_info"
    get "individuals/owns/(:entity_key)" => "individuals#owns", as: :individuals_owns
    # Corporation
    get "corporates/basic_info/(:entity_key)" => "corporates#basic_info", as: :corporates_basic_info
    post "corporates/basic_info/(:entity_key)" => "corporates#basic_info"
    patch "corporates/basic_info/:entity_key" => "corporates#basic_info"
    get "corporates/contact_info/:entity_key" => "corporates#contact_info", as: :corporates_contact_info
    post "corporates/contact_info/:entity_key" => "corporates#contact_info"
    patch "corporates/contact_info/:entity_key" => "corporates#contact_info"
    get "corporates/directors/:entity_key/(:id)" => "corporates#directors", as: :corporates_directors
    get "corporates/director/:entity_key/(:id)" => "corporates#director", as: :corporates_director
    post "corporates/director/:entity_key/(:id)" => "corporates#director"
    patch "corporates/director/:entity_key/(:id)" => "corporates#director"
    delete "corporates/director/:id" => "corporates#director"
    get "corporates/officers/:entity_key/(:id)" => "corporates#officers", as: :corporates_officers
    get "corporates/officer/:entity_key/(:id)" => "corporates#officer", as: :corporates_officer
    post "corporates/officer/:entity_key/(:id)" => "corporates#officer"
    patch "corporates/officer/:entity_key/(:id)" => "corporates#officer"
    delete "corporates/officer/:id" => "corporates#officer"
    get "corporates/stockholders/:entity_key/(:id)" => "corporates#stockholders", as: :corporates_stockholders
    get "corporates/stockholder/:entity_key/(:id)" => "corporates#stockholder", as: :corporates_stockholder
    post "corporates/stockholder/:entity_key/(:id)" => "corporates#stockholder"
    patch "corporates/stockholder/:entity_key/(:id)" => "corporates#stockholder"
    delete "corporates/stockholder/:id" => "corporates#stockholder"
    get "corporates/owns/(:entity_key)" => "corporates#owns", as: :corporates_owns
    # LLC
    get "llc/basic_info/(:entity_key)" => "llc#basic_info", as: :llc_basic_info
    post "llc/basic_info/(:entity_key)" => "llc#basic_info"
    patch "llc/basic_info/:entity_key" => "llc#basic_info"
    get "llc/contact_info/:entity_key" => "llc#contact_info", as: :llc_contact_info
    post "llc/contact_info/:entity_key" => "llc#contact_info"
    patch "llc/contact_info/:entity_key" => "llc#contact_info"
    get "llc/managers/:entity_key/(:id)" => "llc#managers", as: :llc_managers
    get "llc/manager/:entity_key/(:id)" => "llc#manager", as: :llc_manager
    post "llc/manager/:entity_key/(:id)" => "llc#manager"
    patch "llc/manager/:entity_key/(:id)" => "llc#manager"
    delete "llc/manager/:id" => "llc#manager"
    get "llc/members/:entity_key/(:id)" => "llc#members", as: :llc_members
    get "llc/member/:entity_key/(:id)" => "llc#member", as: :llc_member
    post "llc/member/:entity_key/(:id)" => "llc#member"
    patch "llc/member/:entity_key/(:id)" => "llc#member"
    delete "llc/member/:id" => "llc#member"
    get "llc/owns/(:entity_key)" => "llc#owns", as: :llc_owns
    # LLP
    get "llp/basic_info/(:entity_key)" => "llp#basic_info", as: :llp_basic_info
    post "llp/basic_info/(:entity_key)" => "llp#basic_info"
    patch "llp/basic_info/:entity_key" => "llp#basic_info"
    get "llp/contact_info/:entity_key" => "llp#contact_info", as: :llp_contact_info
    post "llp/contact_info/:entity_key" => "llp#contact_info"
    patch "llp/contact_info/:entity_key" => "llp#contact_info"
    get "llp/partners/:entity_key/(:id)" => "llp#partners", as: :llp_partners
    get "llp/partner/:entity_key/(:id)" => "llp#partner", as: :llp_partner
    post "llp/partner/:entity_key/(:id)" => "llp#partner"
    patch "llp/partner/:entity_key/(:id)" => "llp#partner"
    delete "llp/partner/:id" => "llp#partner"
    get "llp/owns/(:entity_key)" => "llp#owns", as: :llp_owns
    # PartnerShip
    get "partnership/basic_info/(:entity_key)" => "partnership#basic_info", as: :partnership_basic_info
    post "partnership/basic_info/(:entity_key)" => "partnership#basic_info"
    patch "partnership/basic_info/:entity_key" => "partnership#basic_info"
    get "partnership/contact_info/:entity_key" => "partnership#contact_info", as: :partnership_contact_info
    post "partnership/contact_info/:entity_key" => "partnership#contact_info"
    patch "partnership/contact_info/:entity_key" => "partnership#contact_info"
    get "partnership/partners/:entity_key/(:id)" => "partnership#partners", as: :partnership_partners
    get "partnership/partner/:entity_key/(:id)" => "partnership#partner", as: :partnership_partner
    post "partnership/partner/:entity_key/(:id)" => "partnership#partner"
    patch "partnership/partner/:entity_key/(:id)" => "partnership#partner"
    delete "partnership/partner/:id" => "partnership#partner"
    get "partnership/owns/(:entity_key)" => "partnership#owns", as: :partnership_owns
    # LimitedPartnerShip
    get "limited_partnership/basic_info/(:entity_key)" => "limited_partnership#basic_info", as: :limited_partnership_basic_info
    post "limited_partnership/basic_info/(:entity_key)" => "limited_partnership#basic_info"
    patch "limited_partnership/basic_info/:entity_key" => "limited_partnership#basic_info"
    get "limited_partnership/contact_info/:entity_key" => "limited_partnership#contact_info", as: :limited_partnership_contact_info
    post "limited_partnership/contact_info/:entity_key" => "limited_partnership#contact_info"
    patch "limited_partnership/contact_info/:entity_key" => "limited_partnership#contact_info"
    get "limited_partnership/limited_partners/:entity_key/(:id)" => "limited_partnership#limited_partners", as: :limited_partnership_limited_partners
    get "limited_partnership/limited_partner/:entity_key/(:id)" => "limited_partnership#limited_partner", as: :limited_partnership_limited_partner
    post "limited_partnership/limited_partner/:entity_key/(:id)" => "limited_partnership#limited_partner"
    patch "limited_partnership/limited_partner/:entity_key/(:id)" => "limited_partnership#limited_partner"
    delete "limited_partnership/limited_partner/:id" => "limited_partnership#limited_partner"
    get "limited_partnership/general_partners/:entity_key/(:id)" => "limited_partnership#general_partners", as: :limited_partnership_general_partners
    get "limited_partnership/general_partner/:entity_key/(:id)" => "limited_partnership#general_partner", as: :limited_partnership_general_partner
    post "limited_partnership/general_partner/:entity_key/(:id)" => "limited_partnership#general_partner"
    patch "limited_partnership/general_partner/:entity_key/(:id)" => "limited_partnership#general_partner"
    delete "limited_partnership/general_partner/:id" => "limited_partnership#general_partner"
    get "limited_partnership/owns/(:entity_key)" => "limited_partnership#owns", as: :limited_partnership_owns
    # Sole Proprietorship
    get "sole_proprietorship/basic_info/(:entity_key)" => "sole_proprietorship#basic_info", as: :sole_proprietorship_basic_info
    post "sole_proprietorship/basic_info/(:entity_key)" => "sole_proprietorship#basic_info"
    patch "sole_proprietorship/basic_info/:entity_key" => "sole_proprietorship#basic_info"
    get "sole_proprietorship/contact_info/:entity_key" => "sole_proprietorship#contact_info", as: :sole_proprietorship_contact_info
    post "sole_proprietorship/contact_info/:entity_key" => "sole_proprietorship#contact_info"
    patch "sole_proprietorship/contact_info/:entity_key" => "sole_proprietorship#contact_info"
    get "sole_proprietorship/owns/(:entity_key)" => "sole_proprietorship#owns", as: :sole_proprietorship_owns
    # Guardianship
    get "guardianship/basic_info/(:entity_key)" => "guardianship#basic_info", as: :guardianship_basic_info
    post "guardianship/basic_info/(:entity_key)" => "guardianship#basic_info"
    patch "guardianship/basic_info/:entity_key" => "guardianship#basic_info"
    get "guardianship/judge/:entity_key/(:id)" => "guardianship#judge", as: :guardianship_judge
    post "guardianship/judge/:entity_key/(:id)" => "guardianship#judge"
    patch "guardianship/judge/:entity_key/(:id)" => "guardianship#judge"
    delete "guardianship/judge/:id" => "guardianship#judge"
    get "guardianship/guardian/:entity_key/(:id)" => "guardianship#guardian", as: :guardianship_guardian
    post "guardianship/guardian/:entity_key/(:id)" => "guardianship#guardian"
    patch "guardianship/guardian/:entity_key/(:id)" => "guardianship#guardian"
    delete "guardianship/guardian/:id" => "guardianship#guardian"
    get "guardianship/ward/:entity_key/(:id)" => "guardianship#ward", as: :guardianship_ward
    post "guardianship/ward/:entity_key/(:id)" => "guardianship#ward"
    patch "guardianship/ward/:entity_key/(:id)" => "guardianship#ward"
    delete "guardianship/ward/:id" => "guardianship#ward"
    get "guardianship/owns/(:entity_key)" => "guardianship#owns", as: :guardianship_owns
    # Tenancy in common
    get "tenancy_in_common/basic_info/(:entity_key)" => "tenancy_in_common#basic_info", as: :tenancy_in_common_basic_info
    post "tenancy_in_common/basic_info/(:entity_key)" => "tenancy_in_common#basic_info"
    patch "tenancy_in_common/basic_info/:entity_key" => "tenancy_in_common#basic_info"
    get "tenancy_in_common/tenant_in_common/:entity_key/(:id)" => "tenancy_in_common#tenant_in_common", as: :tenancy_in_common_tenant_in_common
    post "tenancy_in_common/tenant_in_common/:entity_key/(:id)" => "tenancy_in_common#tenant_in_common"
    patch "tenancy_in_common/tenant_in_common/:entity_key/(:id)" => "tenancy_in_common#tenant_in_common"
    delete "tenancy_in_common/tenant_in_common/:id" => "tenancy_in_common#tenant_in_common"
    get "tenancy_in_common/tenants_in_common/:entity_key" => "tenancy_in_common#tenants_in_common", as: :tenancy_in_common_tenants_in_common
    # Tenancy By Entirety
    get "tenancy_by_entirety/basic_info/(:entity_key)" => "tenancy_by_entirety#basic_info", as: :tenancy_by_entirety_basic_info
    post "tenancy_by_entirety/basic_info/(:entity_key)" => "tenancy_by_entirety#basic_info"
    patch "tenancy_by_entirety/basic_info/:entity_key" => "tenancy_by_entirety#basic_info"
    get "tenancy_by_entirety/spouse/:entity_key/(:id)" => "tenancy_by_entirety#spouse", as: :tenancy_by_entirety_spouse
    post "tenancy_by_entirety/spouse/:entity_key/(:id)" => "tenancy_by_entirety#spouse"
    patch "tenancy_by_entirety/spouse/:entity_key/(:id)" => "tenancy_by_entirety#spouse"
    delete "tenancy_by_entirety/spouse/:id" => "tenancy_by_entirety#spouse"
    get "tenancy_by_entirety/spouses/:entity_key" => "tenancy_by_entirety#spouses", as: :tenancy_by_entirety_spouses
    # Joint Tenancy
    get "joint_tenancy/basic_info/(:entity_key)" => "joint_tenancy#basic_info", as: :joint_tenancy_basic_info
    post "joint_tenancy/basic_info/(:entity_key)" => "joint_tenancy#basic_info"
    patch "joint_tenancy/basic_info/:entity_key" => "joint_tenancy#basic_info"
    get "joint_tenancy/joint_tenant/:entity_key/(:id)" => "joint_tenancy#joint_tenant", as: :joint_tenancy_joint_tenant
    post "joint_tenancy/joint_tenant/:entity_key/(:id)" => "joint_tenancy#joint_tenant"
    patch "joint_tenancy/joint_tenant/:entity_key/(:id)" => "joint_tenancy#joint_tenant"
    delete "joint_tenancy/joint_tenant/:id" => "joint_tenancy#joint_tenant"
    get "joint_tenancy/joint_tenants/:entity_key" => "joint_tenancy#joint_tenants", as: :joint_tenancy_joint_tenants
    # Trust
    get "trust/basic_info/(:entity_key)" => "trust#basic_info", as: :trust_basic_info
    post "trust/basic_info/(:entity_key)" => "trust#basic_info"
    patch "trust/basic_info/:entity_key" => "trust#basic_info"
    get "trust/contact_info/:entity_key" => "trust#contact_info", as: :trust_contact_info
    post "trust/contact_info/:entity_key" => "trust#contact_info"
    patch "trust/contact_info/:entity_key" => "trust#contact_info"
    get "trust/settlors/:entity_key/(:id)" => "trust#settlors", as: :trust_settlors
    get "trust/settlor/:entity_key/(:id)" => "trust#settlor", as: :trust_settlor
    post "trust/settlor/:entity_key/(:id)" => "trust#settlor"
    patch "trust/settlor/:entity_key/(:id)" => "trust#settlor"
    delete "trust/settlor/:id" => "trust#settlor"
    get "trust/trustees/:entity_key/(:id)" => "trust#trustees", as: :trust_trustees
    get "trust/trustee/:entity_key/(:id)" => "trust#trustee", as: :trust_trustee
    post "trust/trustee/:entity_key/(:id)" => "trust#trustee"
    patch "trust/trustee/:entity_key/(:id)" => "trust#trustee"
    delete "trust/trustee/:id" => "trust#trustee"
    get "trust/beneficiaries/:entity_key/(:id)" => "trust#beneficiaries", as: :trust_beneficiaries
    get "trust/beneficiary/:entity_key/(:id)" => "trust#beneficiary", as: :trust_beneficiary
    post "trust/beneficiary/:entity_key/(:id)" => "trust#beneficiary"
    patch "trust/beneficiary/:entity_key/(:id)" => "trust#beneficiary"
    delete "trust/beneficiary/:id" => "trust#beneficiary"
    get "trust/owns/(:entity_key)" => "trust#owns", as: :trust_owns
    #Power of Attorney
    get "power_of_attorney/basic_info/(:entity_key)" => "power_of_attorney#basic_info", as: :power_of_attorney_basic_info
    post "power_of_attorney/basic_info/(:entity_key)" => "power_of_attorney#basic_info"
    patch "power_of_attorney/basic_info/:entity_key" => "power_of_attorney#basic_info"
    # get "power_of_attorney/principals/:entity_key/(:id)" => "power_of_attorney#principals", as: :power_of_attorney_principals
    # get "power_of_attorney/principal/:entity_key/(:id)" => "power_of_attorney#principal", as: :power_of_attorney_principal
    # post "power_of_attorney/principal/:entity_key/(:id)" => "power_of_attorney#principal"
    # patch "power_of_attorney/principal/:entity_key/(:id)" => "power_of_attorney#principal"
    # delete "power_of_attorney/principal/:id" => "power_of_attorney#principal"
    get "power_of_attorney/agents/:entity_key/(:id)" => "power_of_attorney#agents", as: :power_of_attorney_agents
    get "power_of_attorney/agent/:entity_key/(:id)" => "power_of_attorney#agent", as: :power_of_attorney_agent
    post "power_of_attorney/agent/:entity_key/(:id)" => "power_of_attorney#agent"
    patch "power_of_attorney/agent/:entity_key/(:id)" => "power_of_attorney#agent"
    delete "power_of_attorney/agent/:id" => "power_of_attorney#agent"
    get "power_of_attorney/owns/(:entity_key)" => "power_of_attorney#owns", as: :power_of_attorney_owns

  end

  resources :members

  get '/clients/address' => 'clients#address'
  post '/clients/address' => 'clients#address'
  get '/clients/index' => 'clients#index'
  post '/clients/index' => 'clients#index'

  resources :clients do
    collection do
      post :multi_delete
    end
  end

  post '/procedure/actions/checklist_update' => 'procedure/actions#checklist_update'

  get '/procedure/actions/checklist_with_checkbox' => 'procedure/actions#checklist_with_checkbox'
  post '/procedure/actions/checklist_with_checkbox' => 'procedure/actions#checklist_with_checkbox'
  patch '/procedure/actions/checklist_with_checkbox' => 'procedure/actions#checklist_with_checkbox'
  delete '/procedure/actions/checklist_with_checkbox' => 'procedure/actions#checklist_with_checkbox'

  get '/procedure/actions/checklist' => 'procedure/actions#checklist'
  post '/procedure/actions/checklist' => 'procedure/actions#checklist'
  patch '/procedure/actions/checklist' => 'procedure/actions#checklist'
  delete '/procedure/actions/checklist' => 'procedure/actions#checklist'

  get '/procedure/actions/attachment' => 'procedure/actions#attachment'
  post '/procedure/actions/attachment' => 'procedure/actions#attachment'
  patch '/procedure/actions/attachment' => 'procedure/actions#attachment'
  delete '/procedure/actions/attachment' => 'procedure/actions#attachment'

  get '/procedure/actions/member' => 'procedure/actions#member'
  post '/procedure/actions/member' => 'procedure/actions#member'
  patch '/procedure/actions/member' => 'procedure/actions#member'
  delete '/procedure/actions/member' => 'procedure/actions#member'

  get '/properties/member' => 'properties#member'
  post '/properties/member' => 'properties#member'
  patch '/properties/member' => 'properties#member'
  delete '/properties/member' => 'properties#member'

  namespace :procedure do
    resources :actions
  end

  resources :actions
  resources :contacts do
    collection do
      post :multi_delete
    end
  end

  resources :procedures

  get 'comments/property'
  post 'comments/property'

  namespace :property do
    get 'setting' => 'setting#index'
    post 'setting' => 'setting#index'
    get 'setting/emails' => 'setting#emails'
    delete 'setting/emails' => 'setting#emails'
  end

  resources :properties do
    collection do
      post :multi_delete
    end
  end

  resources :transaction_property_offers
  resources :counteroffers

  resources :transaction_baskets do
    collection do
      post :identify_basket_to_qi
    end
  end

  resources :transactions do
    member do
      get :edit_qualified_intermediary, :properties_edit, :qualified_intermediary,
        :terms, :inspection, :closing, :personnel, :get_status, :qi_status
      patch :qualified_intermediary, :properties_update, :terms_update, :inspection_update, :personnel_update, :set_status
      post :personnel_update
      post :closing
    end
    collection do
      post :multi_delete
      get :delete_transaction_property
    end
  end

  resources :transaction_sales, path: :transactions
  resources :transaction_purchases, path: :transactions

  resources :dynamic_fields


  namespace :admin do
    resources :admins do
      member do
        post :set_unset
      end
    end

    resources :users do
      member do
        post :set_unset, :enable_disable
      end
    end

    resources :clients do

    end

    resources :transactions do

    end

    resources :properties do
      collection do
        get :sold_to_purchased
      end
    end

    resources :tenants do
      
    end
    
    resources :default_values do
      collection do
        get :new_property, :new_terms, :new_purchase_property, :new_sell_property,
            :new_sale_transaction
        post :random_mode
        post :toggle_landing_page
        post :toggle_initial_sign_in_modal
        post :set_greeting
      end
    end

  end

  post '/users/set_contact_info' => 'users#set_contact_info'
  
  devise_for :users, :controllers => { }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'home#index'



  get ':controller(/:action(/:id))'
  post ':controller(/:action(/:id))'
  patch ':controller(/:action(/:id))'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
