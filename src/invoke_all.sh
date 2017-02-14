#!/bin/sh
exec scala "$0" "$@"
!#

import java.io._
import scala.io.Source

val HOST = "http://vsearch.glb.prod.walmart.com"
val URL = "/search?cache.mode=bypass&&query=foam%20mattress&cat_id=0&cat=on&facet=on&facet.limit=-1&facet.sort=index&response_group=fe&rows=20&start=140&debug=error&switches=new_site:on;pagination_property:off;4B81:on;entity_search:off;wpa_boost:off&response.type=basic"


try {
    val html = Source.fromURL(HOST + URL, "utf-8")
    val s = html.mkString("")
    println(s)
} catch {
case e: java.io.FileNotFoundException => println(e); None
}



