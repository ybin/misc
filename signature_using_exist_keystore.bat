@echo off
Rem build/target/product/securityĿ¼��������Ĭ��ǩ����ѡ:
Rem 	testkey, platform, shared, media(�����README.txt),
Rem Ӧ�ó�����Android.mk����һ��LOCAL_CERTIFICATE�ֶΣ�
Rem ����ָ�����ĸ�keyǩ����δָ����Ĭ����testkey.

Rem generate private key - the .keystore file
Rem e.g.
Rem keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
Rem keytool -genkey -v -keystore ztecamera.keystore -alias ztecamera -keyalg RSA -keysize 2048 -validity 10000
Rem echo "����keystore�ļ���ɣ����濪ʼǩ����"
Rem echo
Rem pause

Rem sign APK with private key
Rem e.g.
Rem jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore my-release-key.keystore my_application.apk alias_name
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore my_keystore_file -storepass my_storepass -keypass my_keypass -signedjar signed_Camera.apk Camera.apk my_alias
echo.
echo ### ǩ����ɣ����濪ʼ��֤�� ###
echo.
pause
echo.

Rem checkout if APK is signed
Rem e.g.
Rem jarsigner -verify -verbose my_application.apk
jarsigner -verify -verbose signed_Camera.apk
echo.
echo ### ��֤��ɣ����濪ʼapk�ļ����룡 ###
echo.
pause
echo.

Rem align the signed APK to the final APK file
Rem e.g.
Rem zipalign -v 4 your_project_name-unaligned.apk your_project_name.apk
zipalign -v 4 signed_Camera.apk aligned_signed_Camera.apk
echo.
echo ### ���й�����ɣ� ###
echo.
pause
echo.


