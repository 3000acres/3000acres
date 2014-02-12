#!/bin/bash

# tasks to run at deploy time, usually after 'rake db:migrate'

# When adding tasks, do so in chronological order, and note the date
# when it was added.  This will help us know which ones have been run
# and can safely be commented out or removed.

# Default format is:
# echo "YYYY-MM-DD - do something or other"
# rake acres:oneoff:something

# echo "2013-11-13 - set up friendly ID slugs"
# rake acres:oneoff:initialize_friendlyid_slugs

echo "2014-01-15 - set up friendly ID slugs for users"
rake acres:oneoff:initialize_user_slugs

echo "2014-01-15 - set up added_by_user for sites"
rake acres:oneoff:initialize_added_by

echo "2014-02-12 - rename statuses for sites"
rake acres:oneoff:rename_statuses
