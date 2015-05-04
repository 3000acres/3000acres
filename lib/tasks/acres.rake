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

  desc "Load CMS content"
  # this loads CMS snippets and pages from db/seeds.
  # note that it won't overwrite any stuff that has previously been
  # loaded. Also, you might think we could use Comfy Mexican Sofa's
  # fixtures feature for this, but it's a broken mess and I couldn't get
  # it to work, so I did my own thing instead (which at least is readable
  # and you can see what it's doing) -- Skud
  # usage: rake acres:load_cms

  task :load_cms => :environment do
    puts "Loading CMS content..."

    site = Comfy::Cms::Site.find_by(:identifier => '3000acres')

    source_path = Rails.root.join('db', 'seeds', 'cms', 'snippets')
    Dir.glob("#{source_path}/*.snippet").each do |snippet_file|
      snippet_name = File.basename(snippet_file, ".snippet")
      snippet = Comfy::Cms::Snippet.find_by(:identifier => snippet_name)
      if snippet
        puts "  #{snippet_name} snippet -- EXISTS"
      else
        snippet_content = open(snippet_file).read
        snippet = Comfy::Cms::Snippet.create!(
          identifier: snippet_name,
          label: snippet_name,
          site: site,
          content: snippet_content
        )
        snippet.save
        puts "  #{snippet_name} snippet -- CREATED"
      end
    end

    ['Get Started', 'About'].each do |page|
      existing = Comfy::Cms::Page.find_by(:label => page.titleize)
      if existing
        puts "  #{page} page -- EXISTS"
      else
        layout = Comfy::Cms::Layout.find_by(:identifier => 'default')
        topnav = Comfy::Cms::Page.find_by(:label => 'topnav')
        Comfy::Cms::Page.create!(
          label: page.titleize,
          site: site,
          layout: layout,
          parent_id: topnav.id,
          slug: page.squish.downcase.tr(" ","_")
        )
        puts "  #{page} page -- CREATED"
      end
    end
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

    desc "Delete orphaned watches"
    task :delete_orphaned_watches => :environment do
      Watch.find_each do |w|
        if w.user == nil
          puts "Found a missing user"
          w.destroy!
        end
      end
    end

    desc "Send thank you emails to site adders"
    task :send_added_emails => :environment do
      Site.find_each do |s|
        if s.added_by_user
          s.send_added_email
        end
      end
    end
  end
end
