# /tcl/rss-defs.tcl
ad_library {
     procs to generate rss feeds
     procs to help with rssness
     @author jerry@theashergroup.com [jerry@theashergroup.com]
     @creation-date Fri Oct 26 11:43:26 2001
     @cvs-id
}


###
# rss
# generates an rss feed given channel information
# and item information
###

#Convert to ad_register_proc if we plan to keep.
#ns_register_proc GET /*.rss ns_sourceproc
#ns_register_proc POST /*.rss ns_sourceproc
#ns_register_proc HEAD /*.rss ns_sourceproc
#ns_register_proc PUT /*.rss ns_putscript

ad_proc rss_gen_100 {
    {
        -channel_title                  ""
        -channel_link                   ""
        -channel_description            ""
        -image                          ""
        -items                          ""
        -channel_copyright              ""
        -channel_managingEditor         ""
        -channel_webMaster              ""
        -channel_pubDate                ""
    }
} { 
    generate an rss 1.0 xml feed
    very basic rss 1.0, with no modules implemented....
} {

    set rss ""

    if {[empty_string_p $channel_title]} {
        error "argument channel_title not provided"
    }
    if {[empty_string_p $channel_link]} {
        error "argument channel_link not provided"
    }
    if {[empty_string_p $channel_description]} {
        error "argument channel_description not provided"
    }

    set channel_date [clock format [clock seconds] -format "%Y-%m-%dT%H:%M"]

    append rss "<rdf:RDF "
    append rss "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\""
    append rss " xmlns:dc=\"http://purl.org/dc/elements/1.1/\""
    append rss " xmlns=\"http://purl.org/rss/1.0/\""
    append rss ">"
    append rss "<channel rdf:about=\"$channel_link\">\n"

    append rss "<title>"
    append rss [ad_quotehtml $channel_title]
    append rss "</title>\n"

    append rss "<link>"
    append rss $channel_link
    append rss "</link>\n"

    append rss "<description>"
    append rss [ad_quotehtml $channel_description]
    append rss "</description>\n"

    if {[empty_string_p $channel_pubDate]} {
        append rss "<dc:date>$channel_date</dc:date>\n"
    } else {
        append rss "<dc:date>[ad_quotehtml $channel_pubDate]</dc:date>\n"
    }

    if {![empty_string_p $channel_copyright]} {
        append rss "<dc:rights>"
        append rss [ad_quotehtml $channel_copyright]
        append rss "</dc:rights>\n"
    }

    if {![empty_string_p $channel_managingEditor]} {
        append rss "<dc:creator>"
        append rss [ad_quotehtml $channel_managingEditor]
        append rss "</dc:creator>\n"
    }

    if {![empty_string_p $channel_webMaster]} {
        append rss "<dc:publisher>"
        append rss [ad_quotehtml $channel_webMaster]
        append rss "</dc:publisher>\n"
    }


    if {[empty_string_p $image]} {
        set logo_rss "/graphics/openacs_logo_rss.gif"
        set url      [ad_url]
        append       url $logo_rss
        set title    $channel_title
        set link     $channel_link
        set size     [ns_gifsize [ns_url2file $logo_rss]]
        set image [list                                          \
                url $url                                         \
                title $title                                     \
                link $link                                       \
                width [lindex $size 0]                           \
                height [lindex $size 1]]
    }

    array set imarray $image

    # channel image handling
    append rss "<image rdf:resource=\"[ad_quotehtml $imarray(url)]\" />\n"

    append rss "<items>\n"
    append rss "<rdf:Seq>\n"

    # channel item handling
    foreach item $items {
        array unset iarray
        array set iarray $item
        append rss "<rdf:li resource=\"[ad_quotehtml $iarray(link)]\" />\n"
    }

    append rss "</rdf:Seq>\n"
    append rss "</items>\n"
    append rss "</channel>\n"

    # now top level image
    append rss "<image rdf:about=\"$imarray(url)\">\n"
    append rss "<title>[ad_quotehtml $imarray(title)]</title>\n"
    append rss "<url>$imarray(url)</url>\n"
    append rss "<link>[ad_quotehtml $imarray(link)]</link>\n"
    if {[info exists iarray(width)]} {
        set element [ad_quotehtml $iarray(width)]
        append rss "<width>$element</width>\n"
    }
    append rss "</image>\n"

    # now top level items
    foreach item $items {
        array unset iarray
        array set iarray $item
        append rss "<item rdf:about=\"[ad_quotehtml $iarray(link)]\">\n"
        set element [ad_quotehtml $iarray(title)]
        append rss "<title>$element</title>\n"
        append rss "<link>[ad_quotehtml $iarray(link)]</link>\n"
        if {[info exists iarray(description)]} {
            set element [ad_quotehtml $iarray(description)]
            append rss "<description>$element</description>\n"
        }
        if {[info exists iarray(timestamp)]} {
            set element [ad_quotehtml $iarray(timestamp)]
            append rss "<dc:date>$element</dc:date>\n"
        }

        append rss "</item>\n"
    }

    append rss "</rdf:RDF>"
    return $rss

}

ad_proc rss_gen_091 {
    {
        -channel_title                  ""
        -channel_link                   ""
        -channel_description            ""
        -channel_language               "en-us"
        -channel_copyright              ""
        -channel_managingEditor         ""
        -channel_webMaster              ""
        -channel_rating                 ""
        -channel_pubDate                ""
        -channel_lastBuildDate          ""
        -channel_skipDays               ""
        -channel_skipHours              ""
        -image                          ""
        -items                          ""
    }
} { 
    generate an rss 0.91 xml feed
} {

    set rss ""

    if {[empty_string_p $channel_title]} {
        error "argument channel_title not provided"
    }
    if {[empty_string_p $channel_link]} {
        error "argument channel_link not provided"
    }
    if {[empty_string_p $channel_description]} {
        error "argument channel_description not provided"
    }

    append rss "<rss version=\"0.91\">\n"
    append rss "<channel>\n"

    append rss "<title>"
    append rss [ad_quotehtml $channel_title]
    append rss "</title>\n"

    append rss "<link>"
    append rss [ad_quotehtml $channel_link]
    append rss "</link>\n"

    append rss "<description>"
    append rss [ad_quotehtml $channel_description]
    append rss "</description>\n"

    append rss "<language>"
    append rss [ad_quotehtml $channel_language]
    append rss "</language>\n"

    if {![empty_string_p $channel_copyright]} {
        append rss "<copyright>"
        append rss [ad_quotehtml $channel_copyright]
        append rss "</copyright>\n"
    }

    if {![empty_string_p $channel_managingEditor]} {
        append rss "<managingEditor>"
        append rss [ad_quotehtml $channel_managingEditor]
        append rss "</managingEditor>\n"
    }

    if {![empty_string_p $channel_webMaster]} {
        append rss "<webMaster>"
        append rss [ad_quotehtml $channel_webMaster]
        append rss "</webMaster>\n"
    }

    if {![empty_string_p $channel_rating]} {
        append rss "<rating>"
        append rss [ad_quotehtml $channel_rating]
        append rss "</rating>\n"
    }

    if {![empty_string_p $channel_pubDate]} {
        append rss "<pubDate>"
        append rss [ad_quotehtml $channel_pubDate]
        append rss "</pubDate>\n"
    }

    if {![empty_string_p $channel_lastBuildDate]} {
        append rss "<lastBuildDate>"
        append rss [ad_quotehtml $channel_lastBuildDate]
        append rss "</lastBuildDate>\n"
    }

    append rss "<docs>"
    append rss "http://backend.userland.com/stories/rss091"
    append rss "</docs>\n"

    if {![empty_string_p $channel_skipDays]} {
        append rss "<skipDays>"
        append rss [ad_quotehtml $channel_skipDays]
        append rss "</skipDays>\n"
    }

    if {![empty_string_p $channel_skipHours]} {
        append rss "<skipHours>"
        append rss [ad_quotehtml $channel_skipHours]
        append rss "</skipHours>\n"
    }

    if {[empty_string_p $image]} {
        set logo_rss "/graphics/openacs_logo_rss.gif"
        set url      [ad_url]
        append       url $logo_rss
        set title    $channel_title
        set link     $channel_link
        set size     [ns_gifsize [ns_url2file $logo_rss]]
        set image [list                                          \
                url $url                                         \
                title $title                                     \
                link $link                                       \
                width [lindex $size 0]                           \
                height [lindex $size 1]]
    }

    # image handling
    append rss "<image>\n"
    array set iarray $image

    append rss "<title>[ad_quotehtml $iarray(title)]</title>\n"
    append rss "<url>$iarray(url)</url>\n"
    append rss "<link>[ad_quotehtml $iarray(link)]</link>\n"
    if {[info exists iarray(width)]} {
        set element [ad_quotehtml $iarray(width)]
        append rss "<width>$element</width>\n"
    }
    if {[info exists iarray(height)]} {
        set element [ad_quotehtml $iarray(height)]
        append rss "<height>$element</height>\n"
    }
    if {[info exists iarray(description)]} {
        set element [ad_quotehtml $iarray(description)]
        append rss "<description>$element</description>\n"
    }

    append rss "</image>\n"

    # now do the items
    foreach item $items {
        array unset iarray
        array set iarray $item
        append rss "<item>\n"
        set element [ad_quotehtml $iarray(title)]
        append rss "<title>$element</title>\n"
        append rss "<link>[ad_quotehtml $iarray(link)]</link>\n"
        if {[info exists iarray(description)]} {
            set element [ad_quotehtml $iarray(description)]
            if {[info exists iarray(timestamp)]} {
                # if {[info exists iarray(timeformat)]} {
                    # set timeformat $iarray(timeformat)
                # } else {
                    set timeformat "%B %e, %Y %H:%M%p %Z"
                # }
                set timestamp [clock format [clock scan $iarray(timestamp)] \
                        -format $timeformat]
                append element " $timestamp"
            }
            append rss "<description>$element</description>\n"
        }
        append rss "</item>\n"
    }

    append rss "</channel>\n"
    append rss "</rss>\n"
    
    return $rss

}

ad_proc rss_gen {
    {
        -version                        .91
        -channel_title                  ""
        -channel_link                   ""
        -channel_description            ""
        -image                          ""
        -items                          ""
        -channel_language               "en-us"
        -channel_copyright              ""
        -channel_managingEditor         ""
        -channel_webMaster              ""
        -channel_rating                 ""
        -channel_pubDate                ""
        -channel_lastBuildDate          ""
        -channel_skipDays               ""
        -channel_skipHours              ""
    }
} { 
    <pre>
    Generates an RSS XML doc given channel information and item
    information.  Supports versions .91 and 1.0.

    Does not determine if field lengths are valid, nor does it
    determine if field values are of the proper type.

    Doesn't support textInput forms

    Merely creates the XML doc.  GIGO and caveat emptor.

    version is 0.91 or 1.0.  If not present, defaults to 0.91
    
    the default image is openacs/www/graphics/openacs_logo_rss.gif 

    For 0.91, 
    pubdate, copyright, lastbuildate, skipdays, skiphours,
    webmaster, managingeditor fields,
    if not specified are not included in the xml.

    the image parameter is a property list of:
      url $url title $title link $link 
          [width $width] [height $height] [description $description]
      where the elements within brackets are optional

    items are a list of property lists, one for each item
      title $title link $link description $description

    Spec/channel docs url for 0.91 is
    http://backend.userland.com/stories/rss091
    
    For 1.0
    Spec can be found at
    http://groups.yahoo.com/group/rss-dev/files/specification.html
    The 1.0 spec is very primitive: my needs are primitive as of yet,
    and I don't grok the rss 1.0 modules stuff as yet.  Whoops p'gazonga.
    
    </pre>
} {
    set rss "<?xml version=\"1.0\"?>\n"
    switch $version {
        100 -
        1.00 -
        1.0 -
        1 {
            set rss [rss_gen_100                                         \
                    -channel_title           $channel_title              \
                    -channel_link            $channel_link               \
                    -channel_description     $channel_description        \
                    -image                   $image                      \
                    -items                   $items                      \
                    ]
        }
        default {

            set rss [rss_gen_091                                         \
                    -channel_title           $channel_title              \
                    -channel_link            $channel_link               \
                    -channel_description     $channel_description        \
                    -channel_language        $channel_language           \
                    -channel_copyright       $channel_copyright          \
                    -channel_managingEditor  $channel_managingEditor     \
                    -channel_webMaster       $channel_webMaster          \
                    -channel_rating          $channel_rating             \
                    -channel_pubDate         $channel_pubDate            \
                    -channel_lastBuildDate   $channel_lastBuildDate      \
                    -channel_skipDays        $channel_skipDays           \
                    -channel_skipHours       $channel_skipHours          \
                    -image                   $image                      \
                    -items                   $items                      \
                    ]

        }
    }
    return $rss
}

proc_doc rss_lang_widget {{selected_lang en}} {
    creates an html-select field widget with lots of html language
    choices in it
} {
    foreach {value lang} {
        af {Afrikaans}
        sq {Albanian}
        eu {Basque}
        be {Belarusian}
        bg {Bulgarian}
        ca {Catalan}
        zh-cn {Chinese (Simplified)}
        zh-tw {Chinese (Traditional)}
        hr {Croatian}
        cs {Czech}
        da {Danish}
        nl {Dutch}
        nl-be {Dutch (Belgium)}
        nl-nl {Dutch (Netherlands)}
        en {English}
        en-au {English (Australia)}
        en-bz {English (Belize)}
        en-ca {English (Canada)}
        en-ie {English (Ireland)}
        en-jm {English (Jamaica)}
        en-nz {English (New Zealand)}
        en-ph {English (Phillipines)}
        en-za {English (South Africa)}
        en-tt {English (Trinidad)}
        en-gb {English (United Kingdom)}
        en-us {English (United States)}
        en-zw {English (Zimbabwe)}
        fo {Faeroese}
        fi {Finnish}
        fr {French}
        fr-be {French (Belgium)}
        fr-ca {French (Canada)}
        fr-fr {French (France)}
        fr-lu {French (Luxembourg)}
        fr-mc {French (Monaco)}
        fr-ch {French (Switzerland)}
        gl {Galician}
        gd {Gaelic}
        de {German}
        de-at {German (Austria)}
        de-de {German (Germany)}
        de-li {German (Liechtenstein)}
        de-lu {German (Luxembourg)}
        de-ch {German (Switzerland)}
        el {Greek}
        hu {Hungarian}
        is {Icelandic}
        in {Indonesian}
        ga {Irish}
        it {Italian}
        it-it {Italian (Italy)}
        it-ch {Italian (Switzerland)}
        ja {Japanese}
        ko {Korean}
        mk {Macedonian}
        no {Norwegian}
        pl {Polish}
        pt {Portuguese}
        pt-br {Portuguese (Brazil)}
        pt-pt {Portuguese (Portugal)}
        ro {Romanian}
        ro-mo {Romanian (Moldova)}
        ro-ro {Romanian (Romania)}
        ru {Russian}
        ru-mo {Russian (Moldova)}
        ru-ru {Russian (Russia)}
        sr {Serbian}
        sk {Slovak}
        sl {Slovenian}
        es {Spanish}
        es-ar {Spanish (Argentina)}
        es-bo {Spanish (Bolivia)}
        es-cl {Spanish (Chile)}
        es-co {Spanish (Colombia)}
        es-cr {Spanish (Costa Rica)}
        es-do {Spanish (Dominican Republic)}
        es-ec {Spanish (Ecuador)}
        es-sv {Spanish (El Salvador)}
        es-gt {Spanish (Guatemala)}
        es-hn {Spanish (Honduras)}
        es-mx {Spanish (Mexico)}
        es-ni {Spanish (Nicaragua)}
        es-pa {Spanish (Panama)}
        es-py {Spanish (Paraguay)}
        es-pe {Spanish (Peru)}
        es-pr {Spanish (Puerto Rico)}
        es-es {Spanish (Spain)}
        es-uy {Spanish (Uruguay)}
        es-ve {Spanish (Venezuela)}
        sv {Swedish}
        sv-fi {Swedish (Finland)}
        sv-se {Swedish (Sweden)}
        tr {Turkish}
        uk {Ukranian}
    } {
        
        if {[string equal $value $selected_lang]} {
            set selected SELECTED
        } else {
            set selected ""
        }
        
        lappend options "<option value='$value' $selected>$lang"
        
    }
    return "\n\n<select name=lang>\n[join $options \n]\n</select>\n\n
    "
}

###
# simple httppost to weblogs
###

proc_doc rss_weblogUpdatesping {
    blog_title
    blog_url
    {location http://rpc.weblogs.com/RPC2}
    {timeout 30}
    {depth 0}
} {
    sends the xml/rpc message weblogUpldates.ping to weblogs.com
    returns 1 if successful and logs the result
} {
    ns_log notice rss_weblogupdatesping:
    if [catch {
        if {[incr depth] > 10} {
            return -code error "rss_weblogUpdatesping:  Recursive redirection:  $location"
        }
        set req_hdrs [ns_set create]

        set message "<?xml version=\"1.0\"?>
<methodCall>
  <methodName>weblogUpdates.ping</methodName>
  <params>
    <param>
      <value>[ad_quotehtml $blog_title]</value>
    </param>
    <param>
      <value>[ad_quotehtml $blog_url]</value>
    </param>
  </params>
</methodCall>"

        # headers necesary for a post and the form variables
        ns_set put $req_hdrs "Content-type" "text/xml"
        ns_set put $req_hdrs "Content-length" [string length $message]
        set http [ns_httpopen POST $location $req_hdrs 30 $message]
        set rfd [lindex $http 0]
        set wfd [lindex $http 1]
        set rpset [lindex $http 2]

        flush $wfd
        close $wfd

    ns_log notice rss_weblogupdatesping: pinging for blog $blog_title and url $blog_url
    ns_log notice message: \"$message\"

        set headers $rpset
        set response [ns_set name $headers]
        set status [lindex $response 1]
        if {$status == 302} {
            set location [ns_set iget $headers location]
            if {$location != ""} {
                ns_set free $headers
                close $rfd
                return [rss_weblogUpdatesping $blog_title $blog_url $location $timeout $depth]
            }
        }
        set length [ns_set iget $headers content-length]
        if [string match "" $length] {set length -1}
        set err [catch {
            while 1 {
                set buf [_ns_http_read $timeout $rfd $length]
                append page $buf
                if [string match "" $buf] break
                if {$length > 0} {
                    incr length -[string length $buf]
                    if {$length <= 0} break
                }
            }
        } errMsg]
        ns_set free $headers
        close $rfd
        if $err {
            global errorInfo
            return -code error -errorinfo $errorInfo $errMsg
        }
    } errmsg ] {
        ns_log error rss_weblogUpdatesping error: $errmsg
        return -1
    } else {
        ns_log notice rss_weblogUpdatesping: $page
        return 1
    }
}

