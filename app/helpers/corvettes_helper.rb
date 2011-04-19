module corvettesHelper
  
  def new_corvette_link
    link_to "create a #{ARMADA_COMPONENT.downcase}", new_members_corvette_path
  end

  def new_corvette_button
    button_to "New #{ARMADA_COMPONENT}!", new_members_corvette_path, :method => :get
  end

end