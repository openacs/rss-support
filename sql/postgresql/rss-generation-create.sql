create function inline_0 ()
returns integer as '
begin
    PERFORM acs_object_type__create_type (
	''rss_gen_subscr'',		 	-- object_type
	''RSS Generation Subscription'',	-- pretty_name
	''RSS Generation Subscriptions'',	-- pretty_plural
	''acs_object'',				-- supertype
	''rss_gen_subscrs'',			-- table_name
	''subscr_id'',				-- id_column
	null,					-- package_name
	''f'',					-- abstract_p
	null,					-- type_extension_table
	''rss_gen_subscr__name''		-- name_method
	);

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

create function inline_1 ()
returns integer as '
begin
    PERFORM acs_attribute__create_attribute (
	  ''rss_gen_subscr'',			-- object_type
	  ''IMPL_ID'',				-- attribute_name
	  ''integer'',				-- datatype
	  ''Implementation ID'',		-- pretty_name
	  ''Implementation IDs'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',			-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''rss_gen_subscr'',			-- object_type
	  ''CONTEXT_IDENTIFIER'',		-- attribute_name
	  ''integer'',				-- datatype
	  ''Context Identifier'',		-- pretty_name
	  ''Context Identifiers'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',			-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''rss_gen_subscr'',			-- object_type
	  ''TIMEOUT'',				-- attribute_name
	  ''integer'',				-- datatype
	  ''Timeout'',				-- pretty_name
	  ''Timeouts'',				-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',			-- storage
	  ''f''					-- static_p
	);

    return 0;
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();

create table rss_gen_subscrs (
   subscr_id                      integer
				  constraint rss_gen_subscrs_id_fk
				  references acs_objects(object_id)
				  constraint rss_gen_subscrs_id_pk
				  primary key,
   impl_id			  integer
				  constraint rss_gen_subscrs_impl_nn
				  not null
				  constraint rss_gen_subscrs_impl_fk
				  references acs_sc_impls(impl_id),
   context_identifier		  varchar(100)
				  constraint rss_gen_subscrs_ctx_nn
				  not null,
   timeout			  integer
				  constraint rss_gen_subscrs_timeout_nn
				  not null
);

comment on table rss_gen_subscrs is '
   Table for storing the different parts of the site we will generate
   summaries for.
';

comment on column rss_gen_subscrs.subscr_id is '
   Subscriptions are ACS objects.  They will typically inherit
   permission from a package instance.
';

comment on column rss_gen_subscrs.impl_id is '
   The implementation which will provide summary information and
   update status.
';

comment on column rss_gen_subscrs.context_identifier is '
   An identifier unique to the site section whose content is to be
   summarized.  A context identifier need not be a package instance
   id.  We will suggest a convention but the format is entirely up to
   the implementors.
';

comment on column rss_gen_subscrs.timeout is '
   The minimum number of seconds between summary builds. 
';
