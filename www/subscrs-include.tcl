if [info exists user_id] {
    set maybe_restrict_to_user "and creation_user = :user_id"
} else {
    set maybe_restrict_to_user ""
}

db_multirow -extend { last_build_pretty } subscrs get_subscrs {} {
    set last_build_ansi [lc_time_system_to_conn $last_build_ansi]
    set last_build_pretty [lc_time_fmt $last_build_ansi "%x %X"]

    if [string equal $channel_title ""] {
	set channel_title "Subscription #$subscr_id"
    }
}
