ad_library {
    Tests for utilities
}

aa_register_case \
    -cats {api smoke} \
    -procs {
        rss_package_id
    } \
    rss__package_id {
        Test rss_package_id
    } {
        aa_equals "rss_package_id returns the expected result" \
            [rss_package_id] \
            [db_string get_package {
                select package_id from apm_packages where package_key = 'rss-support'
            }]
    }

aa_register_case \
    -cats {api smoke} \
    -procs {
        rss_first_url_for_package_id
    } \
    rss__first_url_for_package_id {
        Test rss_first_url_for_package_id
    } {
        set package_id [db_string get_mounted_package {
            select min(object_id) from site_nodes
        }]

        aa_equals "rss_first_url_for_package_id returns the expected result" \
            [rss_first_url_for_package_id $package_id] \
            [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]
    }
