
<property name="context">{/doc/rss-support {RSS Support}} {RSS Support: Bboard Sample Implementation}</property>
<property name="doc(title)">RSS Support: Bboard Sample Implementation</property>
<master>
<h2>Bboard Sample Implementation</h2>

by <a href="mailto:aegrumet\@alum.mit.edu">Andrew Grumet</a>

Back to <a href="index">RSS Support</a>
<p>The steps:</p>
<ol>
<li>Install the rss-support package, and mount a single instance at
a convenient location (e.g. <code>/rss</code>). Note that
rss-support is a service package and a singleton.</li><li>Create one or more implentations Of the RssGenerationSubscriber
interface. This <a href="bboard-rss-sc-create-sql.txt">example</a>
registers an implementation for bboard forums.</li><li>Define the implementation procs. This <a href="bboard-rss-sc-procs-tcl.txt">example</a> implements the contracted
procs.</li><li>Create a subscription for each forum to be summarized. This can
be accomplished by querying for the implentation&#39;s
<code>impl_id</code> as follows
<blockquote><pre>
select acs_sc_impl__get_id('RssGenerationSubscriber','bboard_forum');
</pre></blockquote>
and navigating to
/rss/subscr-ae?impl_id=$impl_id&amp;summary_context_id=$forum_id
(note that subscr-ae doesn&#39;t accept <code>impl_name</code> as a
URL parameter for security reasons).</li><li>The scheduled proc <code>rss_gen_service</code> will create a
binding for the implementation and generate summaries for each
subscription if the conditions for summary generation are met (i.e.
if the subscription timeout interval has elapsed since the last
build and if the time returned by lastUpdated is greater than the
time of the last report built).</li><li>Summaries can be found at
<code>/${RssGenOutputDirectory}/${ImplementationName}/${summary_context_id}/rss.xml</code>
</li>
</ol>
<hr>
<address><a href="mailto:aegrumet\@alum.mit.edu">aegrumet\@alum.mit.edu</a></address>
