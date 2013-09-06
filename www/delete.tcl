ad_page_contract {
    Confirm deletion of a subscription.
} {
    subscr_id:notnull,naturalnum
    return_url:notnull
}

permission::require_permission -object_id $subscr_id -privilege admin

db_1row subscr_info {}

if {$channel_title eq ""} {
    set channel_title "Summary Context $summary_context_id"
}

set context [list Delete]

if [file exists [rss_gen_report_file -subscr_id $subscr_id]] {
    set offer_file 1
    set report_url [rss_gen_report_file -subscr_id $subscr_id]
} else {
    set offer_file 0
}
