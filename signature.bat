
REM build/target/product/security目录中有四组默认签名可选:
REM 	testkey, platform, shared, media(具体见README.txt),
REM 应用程序中Android.mk中有一个LOCAL_CERTIFICATE字段，
REM 由它指定用哪个key签名，未指定的默认用testkey.

REM generate private key - the .keystore file
keytool -genkey -v -keystore syb_platform.keystore -alias ybsolar -keyalg RSA -keysize 2048 -validity 10000

REM sign APK with private key
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore syb_platform.keystore -signedjar signed_Camera.apk Camera.apk ybsolar

REM checkout if APK is signed
REM jarsigner -verify -verbose Camera.apk

REM align the signed APK to the final APK file
zipalign -v 4 signed_Camera.apk aligned_signed_Camera.apk