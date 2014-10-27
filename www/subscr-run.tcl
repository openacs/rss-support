ad_page_contract {
    Run a report for the given subscription.
} {
    subscr_id:notnull,naturalnum
    return_url:notnull
}

permission::require_permission -object_id $subscr_id -privilege admin

rss_gen_report $subscr_id

ad_returnredirect $return_url
