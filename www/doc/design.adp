
<property name="context">{/doc/rss-support/ {RSS Support}} {RSS Support Design Notes}</property>
<property name="doc(title)">RSS Support Design Notes</property>
<master>
<style>
div.sect2 > div.itemizedlist > ul.itemizedlist > li.listitem {margin-top: 16px;}
div.sect3 > div.itemizedlist > ul.itemizedlist > li.listitem {margin-top: 6px;}
</style>              
<h2>RSS Support Design Notes</h2>

by <a href="mailto:aegrumet\@alum.mit.edu">Andrew Grumet</a>
,
<a href="mailto:jerry\@theashergroup.com">Jerry Asher</a>
 and
<a href="mailto:dave\@thedesignexperience.org">Dave Bauer</a>
<p>From the <a href="http://groups.yahoo.com/group/rss-dev/files/specification.html">specification</a>,</p>
<blockquote><em>RDF Site Summary (RSS) is a lightweight
multipurpose extensible metadata description and syndication
format. RSS is an XML application, conforms to the W3C&#39;s RDF
Specification and is extensible via XML-namespace and/or RDF based
modularization.</em></blockquote>

This service package provides low-level support for generating and
parsing RSS feeds.
<h3>1. Feed generation</h3>

Feed generation is the process of summarizing local content as RSS
xml. To generate a feed we need to know
<ul>
<li>the site context whose content is to be summarized,</li><li>how to retrieve the various required and optional metadata
fields</li><li>whether any changes have been made since the last summary was
built</li><li>how often to rebuild the summary (if changes are present)</li>
</ul>

The last item is included with an eye toward performance. In the
event that a particular summary is expensive to produce, we may opt
to rebuild at most every N minutes (or hours, or days).
<p><strong>Usage scenarios</strong></p>
<ul>
<li>Publisher wishes to syndicate the Bar Forum in the Foo Bboard
package instance.</li><li>Luckily, the bboard package implements the summary service
contract for individual forums.</li><li>Programmer registers the context identifier for the Bar Forum
with the summary service, indicating that the summary should be
built no more than once per hour.</li><li>Summary is available at
/some/url/specific/to/bar/forum/summary.xml</li>
</ul>
<p><strong>Service contract</strong></p>
<p>The feed generation service contract is called
<code>RssGenerationSubscriber</code> and consists of two
operations.</p>
<ol>
<li>
<code>Datasource(summary_context_id)</code> returns a data
structure that contains all required metadata fields plus
configuration information such as the RSS version to be used (0.91
or 1.00 are supported at present). This data structure contains
everything needed to run <code>rss_gen</code>.</li><li>
<code>LastUpdated(summary_context_id)</code> returns a
timestamp that is used to determine if the live summary is out of
date. The timestamp is given as the number of seconds since
midnight on January 1, 1970, i.e. Unix time.</li>
</ol>
<p><strong>Under the hood</strong></p>
<p>
<em>RSS files.</em>All summaries are static files. They are
served from a static directory under the webroot specific by the
RssGenOutputDirectory, which defaults to <code>rss</code>. The full
path to an RSS file is given by</p>
<blockquote><pre>
/${RssGenOutputDirectory}/${ImplementationName}/${summary_context_id}/rss.xml
</pre></blockquote>

Note: we assume that <code>${ImplementationName}</code>
 and
<code>${summary_context_id}</code>
 contain OS- and URL-friendly
characters.
<p>
<em>Subscription.</em> A programmer registers a context with the
summary service through API functions (we can make it possible
through web UI as well if that makes sense).</p>
<p>
<em>Summary context.</em> A summary context is a
content-containing domain which implements the summary service
contract. A summary context is not identical to a package instance.
For example, a single bboard package instance might contain 3
summary contexts, one for each of the forums in the instance. The
summary context must, however, be an acs_object for permissioning
purposes (create a shell acs_object if necessary). Only one
subscription is allowed per summary context.</p>
<p>
<em>Service.</em> A scheduled proc runs through all subscribed
contexts, checking to see if the live summary is stale and also if
the minimum "quiet time" has elapsed. If the conditions
for rebuild are met for a context, the scheduled proc pulls out the
context&#39;s summary data via <code>Datasource</code> and uses the
information to build a new summary page. This generic and simple
scheme can be used to dispatch different versions of the summary
builder as well as to support extensibility via modules.
<font color="red">Warning:</font> This design expects the output of
<code>Datasource</code> to be reasonably small, as we will have to
parse this list-of-lists to generate a summary.</p>
<hr>
<address>
<a href="mailto:aegrumet\@alum.mit.edu">aegrumet\@alum.mit.edu</a>, <a href="mailto:jerry\@theashergroup.com">jerry\@theashergroup.com</a>,
<a href="mailto:dave\@thedesignexperience.org">dave\@thedesignexperience.org</a>
</address>
