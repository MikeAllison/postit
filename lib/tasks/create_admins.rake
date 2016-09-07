namespace :db do
  desc 'Create Admins and Moderators'
  task create_admins: :environment do
    User.create([
      { username: 'AdminUser', password: 'pw', time_zone: Time.zone.name, role: 2 },
      { username: 'ModerUser', password: 'pw', time_zone: Time.zone.name, role: 1 },
      { username: 'GuestMod', password: 'p0st1t', time_zone: Time.zone.name, role: 1},
      { username: 'GuestAdmin', password: 'p0st1t', time_zone: Time.zone.name, role: 2 }
    ])
  end
end
