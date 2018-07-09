

DO $$
BEGIN
   update acs_attributes set
      datatype = 'timestamp'
    where object_type = 'rss_gen_subscr'
      and attribute_name = 'LASTBUILD';
END$$;
