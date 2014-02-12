namespace :acres do

  desc "Add an admin user, by name"
  # usage: rake acres:admin_user name=skud

  task :admin_user => :environment do

    member = User.find_by_name(ENV['name']) or raise "Usage: rake acres:admin_user name=whoever (name is case-sensitive)"
    admin  = Role.find_or_create_by_name!('admin')
    member.roles << admin
  end

  desc "Upload local government areas from a CSV file"
  # usage: rake acres:import_lgas file=filename.csv

  task :import_lgas => :environment do
    require 'csv'
    @file = ENV['file'] or raise "Usage: rake acres:import_lgas file=file.csv"

    puts "Loading local government areas from #{@file}..."
    CSV.foreach(@file) do |row|
      LocalGovernmentArea.create!(:name => row[0])
      print "."
    end
    print "\n"
    puts "Finished loading local government areas"

  end

  desc "Depopulate Null Island"
  # this fixes up any sites who has erroneously wound up with a 0,0 lat/long
  # this code is inherited from Growstuff, and is untested (and 
  # possibly unneeded) as yet
  task :depopulate_null_island => :environment do
    Site.find_each do |m|
      if m.location and (m.latitude == nil and m.longitude == nil)
        m.geocode
        m.save
      end
    end
  end

  desc "One-off tasks needed at various times and kept for posterity"
  namespace :oneoff do
    desc "Create friendly_id slugs for existing sites"
    task :initialize_friendlyid_slugs => :environment do
      Site.find_each do |m|
        m.slug = nil
        m.save!
      end
    end

    desc "Create friendly_id slugs for existing users"
    task :initialize_user_slugs => :environment do
      User.find_each do |m|
        m.slug = nil
        m.save!
      end
    end

    desc "Set added_by_user for sites"
    task :initialize_added_by => :environment do
      Site.find_each do |m|
        unless m.added_by_user
          u = User.first
          m.added_by_user = u
          m.save!
        end
      end
    end

    desc "Rename statuses for sites"
    task :rename_statuses => :environment do
      Site.find_each do |s|
        if s.status == 'suitable'
          s.status = 'potential'
        elsif s.status == 'in-progress'
          s.status = 'proposed'
        end
        s.save!
      end
    end

  end
end
