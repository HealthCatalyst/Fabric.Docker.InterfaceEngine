#!/bin/sh -l
JAVA_OPTS="$JAVA_OPTS -Dorg.eclipse.jetty.util.log.class=org.eclipse.jetty.util.log.StdErrLog -Dorg.eclipse.jetty.LEVEL=DEBUG -Dorg.eclipse.jetty.servlet.LEVEL=ALL"
echo "--- JAVA_OPTS ---"
echo $JAVA_OPTS
echo "-----------------"