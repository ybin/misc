@echo off
:: clojure laucher for Windows

setlocal

:: clojure language
set clojure-jar=E:\Git\clojure\clojure-1.5.1\clojure-1.5.1.jar
:: self-defined clojure lib
set clojure-lib=E:\Git\clojure\workspace\clojure_lib
:: self-defined java lib
set java-lib=E:\Git\clojure\workspace\java_lib

set classpath=%clojure-jar%;%clojure-lib%;%java-lib%\App.jar
java -cp %classpath% clojure.main %1

endlocal