#!/bin/sh
exec scala "$0" "$@"
!#

import java.io._
import scala.io.Source

val hard_sort   = "&sort"
val soft_sort   = "&soft_sort"
val browse      = "&cat_id=3"
val search      = "&cat_id=0"
val facet       = "&facet.filter.query"
val third_row   = "&start=60"
val seventh_row   = "&start=140"

val file_prefix = "output"


val w_third_row = new PrintWriter(new File(file_prefix+"_third_row.txt" ))
val w_seventh_row = new PrintWriter(new File(file_prefix+"_seventh_row.txt" ))
val w_rest = new PrintWriter(new File(file_prefix+"_left.txt" ))
val w_hard_sort = new PrintWriter(new File(file_prefix+"_hard_sort.txt" ))
val w_soft_sort = new PrintWriter(new File(file_prefix+"_soft_sort.txt" ))
val w_browse = new PrintWriter(new File(file_prefix+"_browse.txt" ))
val w_facet_browse = new PrintWriter(new File(file_prefix+"_facet_browse.txt" ))
val w_facet_search = new PrintWriter(new File(file_prefix+"_facet_search.txt" ))
val w_search = new PrintWriter(new File(file_prefix+"_search.txt"))

val max_rows = 1250

val HOST1 = "http://vsearch.glb.prod.walmart.com" //"http://vsearch-kaosprod.glb.prod.walmart.com"
val HOST2 = "http://vsearch.glb.prod.walmart.com"


var c_hard_sort     = 0
var c_soft_sort     = 0
var c_browse        = 0
var c_facet_browse  = 0
var c_facet_search  = 0
var c_search        = 0
var c_third_row     = 0
var c_seventh_row   = 0

var total_counter = 0;

val filename = "httperf_prod_url_7days_10M_util_2016-09-19_multiline.txt"
for (line <- Source.fromFile(filename).getLines) {
if ( line.isEmpty == false && line.startsWith("search")) {
        
        line match {
            case line if (line.contains(third_row) && c_third_row < max_rows) => c_third_row = c_third_row + 1; w_third_row.write("/"+line+"\n");invoke(line,"third row")
            case line if (line.contains(seventh_row) && c_seventh_row < max_rows) => c_seventh_row = c_seventh_row + 1; w_seventh_row.write("/"+line+"\n");invoke(line, "seventh row")
            case line if (line.contains(browse) && line.contains(facet) && c_facet_browse < max_rows) => c_facet_browse=c_facet_browse+1; w_facet_browse.write("/"+line+"\n");invoke(line,"facet browser")
            case line if (line.contains(search) && line.contains(facet) && c_facet_search < max_rows) => c_facet_search=c_facet_search+1; w_facet_search.write("/"+line+"\n");invoke(line,"facet search")
            case line if (! line.contains(search) && c_browse< max_rows) => c_browse=c_browse+1; w_browse.write("/"+line+"\n");invoke(line,"browse")
            case line if (line.contains(soft_sort) && c_soft_sort < max_rows) => c_soft_sort=c_soft_sort+1; w_soft_sort.write("/"+line+"\n");invoke(line,"soft sort")
            case line if (line.contains(hard_sort) && c_hard_sort < max_rows) => c_hard_sort=c_hard_sort+1; w_hard_sort.write("/"+line+"\n");invoke(line,"hard sort")
            case line if (line.contains(search) && c_search < max_rows) => c_search=c_search+1; w_search.write("/"+line+"\n");invoke(line,"search")
            case _ => w_rest.write("/"+line+"\n")
        }
    }
}

w_rest.close
w_hard_sort.close
w_soft_sort.close
w_browse.close
w_facet_browse.close
w_facet_search.close
w_search.close
w_third_row.close
w_seventh_row.close


def invoke(URL:String, src:String) = {
    println(s"counter:$total_counter\tsrc:$src")
    total_counter = total_counter + 1
    try {
        val html = Source.fromURL(HOST1 + "/" + URL, "utf-8")
        val txt = html.mkString("")
        // if (txt.contains("404"))
        //     println(txt)
    } catch {
        case e: java.lang.Exception => println(); println(src); println(HOST1+"/" + URL);println(e); None
    }
}
