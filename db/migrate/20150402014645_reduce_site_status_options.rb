class ReduceSiteStatusOptions < ActiveRecord::Migration
  def change
    # Use potential instead of unknown, its nicer and potential is not used at all currently.
    Site.where("status = 'unknown'").update_all( "status = 'potential'")
    # There aren't any unsuitable sites in use anyway but what the hell.
    Site.where("status = 'unsuitable'").update_all( "status = 'potential'")
  end
end
