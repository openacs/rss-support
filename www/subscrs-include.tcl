if [info exists user_id] {
    set maybe_restrict_to_user "and creation_user = :user_id"
} else {
    set maybe_restrict_to_user ""
}

db_multirow subscrs get_subscrs {} {
    if [string equal $channel_title ""] {
	set channel_title "Subscription #$subscr_id"
    }
}
