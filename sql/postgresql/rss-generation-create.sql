create table rss_generation_subscriptions (
   subscription_id			  integer,
   impl_name				  varachar(100),
   context_identifier			  varchar(100),
   timeout				  integer
);

comment on table rss_generation_subscriptions is '
   Table for storing the different parts of the site we will generate
   summaries for.
';

comment on column rss_generation_subscriptions.subscription_id is '
   Subscriptions are ACS objects.  They will typically inherit
   permission from a package instance.
';

comment on column rss_generation_subscriptions.impl_name is '
   The implementation which will provide summary information and
   update status.
';

comment on column rss_generation_subscriptions.context_identifier is '
   An identifier unique to the site section whose content is to be
   summarized.  A context identifier need not be a package instance
   id.  We will suggest a convention but the format is entirely up to
   the implementors.
';

comment on column rss_generation_subscriptions.timeout is '
   The minimum number of seconds between summary builds. 
';
