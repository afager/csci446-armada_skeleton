PaperTrail.whodunnit = 'Seed Data Script'


# Seed the roles.
Role.create!(:name => 'developer', :description => 'The system developer. There is no higher access level.')
Role.create!(:name => 'administrator', :description => 'A system administrator. Full access to all features.')
Role.create!(:name => 'member', :description => 'A typical application user.')


# Seed developer users.
r = Role.find_by_name('developer')

# FIXME
andrew = User.new(:first_name => 'Andrew',
                         :last_name => 'Fager',
                         :email => 'afager@mines.edu',
                         :password => 'Asher00',
                         :password_confirmation => 'Asher00',
                         :role => r)
andrew.save_without_session_maintenance

# FIXME
joe = User.new(:first_name => 'Joe',
                         :last_name => 'Martinez',
                         :email => 'joemarti@mines.edu',
                         :password => 'joma9202',
                         :password_confirmation => 'joma9202',
                         :role => r)
joe.save_without_session_maintenance

yong = User.new(:first_name => 'Yong',
                :last_name => 'Bakos',
                :email => 'ybakos@mines.edu',
                :password => 'changeme',
                :password_confirmation => 'changeme',
                :role => r)
yong.save_without_session_maintenance

