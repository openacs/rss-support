#

# ad_proc rss_gen_service {}
#
# This scheduled proc does the following
#
# 1. loop through all subscriptions; for each subscription:
# 2. compare last time since last run against timeout
# 3. if timeout exceeded, query LastUpdated
# 4. if last updated > last run time, build report
#
