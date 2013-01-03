
REM build/target/product/securityĿ¼��������Ĭ��ǩ����ѡ:
REM 	testkey, platform, shared, media(�����README.txt),
REM Ӧ�ó�����Android.mk����һ��LOCAL_CERTIFICATE�ֶΣ�
REM ����ָ�����ĸ�keyǩ����δָ����Ĭ����testkey.

REM generate private key - the .keystore file
keytool -genkey -v -keystore syb_platform.keystore -alias ybsolar -keyalg RSA -keysize 2048 -validity 10000

REM sign APK with private key
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore syb_platform.keystore -signedjar signed_Camera.apk Camera.apk ybsolar

REM checkout if APK is signed
REM jarsigner -verify -verbose Camera.apk

REM align the signed APK to the final APK file
zipalign -v 4 signed_Camera.apk aligned_signed_Camera.apk