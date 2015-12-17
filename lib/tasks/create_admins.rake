namespace :db do
  desc 'Create Admin and Moderator'
  task :create_admins => :environment do
    User.create([
      { username: 'AdminUser', password: 'pw', time_zone: Time.zone.name, role: 2 },
      { username: 'ModerUser', password: 'pw', time_zone: Time.zone.name, role: 1 }
    ])
  end
end
