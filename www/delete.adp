<master>
<property name="title">Delete a Subcription</property>

<h2>Delete Subscription</h2>
@context_bar@
<hr>

<blockquote>
Channel: <if @channel_link@ eq "">@channel_title@</if><else>
<a href="@channel_link@">@channel_title@</a></else>
<form action=delete-2>
<input type=hidden name=subscr_id value="@subscr_id@">
<input type=hidden name=return_url value="@return_url@">
<if @offer_file@ eq 1>
<input type=checkbox name=delete_file_p>Delete report (<a href="@report_url@">@report_url@</a>)
</if>
<p>
<input type=submit value="Really delete?">
<input type=button onclick="history.back()" value="No, I want to go back">
</form>
</blockquote>
