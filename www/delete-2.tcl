ad_page_contract  {
    Delete the subscription, and maybe the report.
} {
    subscr_id:notnull,naturalnum
    return_url:localurl,notnull
    delete_file_p:boolean,optional
}

permission::require_permission -object_id $subscr_id -privilege admin

if {[info exists delete_file_p]} {
    file delete -- [rss_gen_report_file -subscr_id $subscr_id]
}

db_exec_plsql delete_subscr {}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
