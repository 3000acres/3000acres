#!/bin/bash

# tasks to run at deploy time, usually after 'rake db:migrate'

# When adding tasks, do so in chronological order, and note the date
# when it was added.  This will help us know which ones have been run
# and can safely be commented out or removed.

# Default format is:
# echo "YYYY-MM-DD - do something or other"
# rake acres:oneoff:something

echo "2013-11-11 - import LGAs"
rake acres:import_lgas file=db/seeds/local_government_areas.csv
