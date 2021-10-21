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
