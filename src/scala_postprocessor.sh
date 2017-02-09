#!/bin/sh
exec scala "$0" "$@"
!#

import java.io._
import scala.io.Source
val writer = new PrintWriter(new File("httperf_prod_url_7days_10M_util_2016-09-19_multiline_new.txt" ))
val filename="httperf_prod_url_7days_10M_util_2016-09-19_multiline.txt"
for (line <- Source.fromFile(filename).getLines) {
        if (line.isEmpty == false)
           writer.write(line.replace("searc","search")+"\n")
}
writer.close
