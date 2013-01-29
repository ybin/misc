@echo off
Rem build/target/product/security目录中有四组默认签名可选:
Rem 	testkey, platform, shared, media(具体见README.txt),
Rem 应用程序中Android.mk中有一个LOCAL_CERTIFICATE字段，
Rem 由它指定用哪个key签名，未指定的默认用testkey.

Rem generate private key - the .keystore file
Rem e.g.
Rem keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
Rem keytool -genkey -v -keystore ztecamera.keystore -alias ztecamera -keyalg RSA -keysize 2048 -validity 10000
Rem echo "生成keystore文件完成，下面开始签名！"
Rem echo
Rem pause

Rem sign APK with private key
Rem e.g.
Rem jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore my-release-key.keystore my_application.apk alias_name
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore my_keystore_file -storepass my_storepass -keypass my_keypass -signedjar signed_Camera.apk Camera.apk my_alias
echo.
echo ### 签名完成，下面开始验证！ ###
echo.
pause
echo.

Rem checkout if APK is signed
Rem e.g.
Rem jarsigner -verify -verbose my_application.apk
jarsigner -verify -verbose signed_Camera.apk
echo.
echo ### 验证完成，下面开始apk文件对齐！ ###
echo.
pause
echo.

Rem align the signed APK to the final APK file
Rem e.g.
Rem zipalign -v 4 your_project_name-unaligned.apk your_project_name.apk
zipalign -v 4 signed_Camera.apk aligned_signed_Camera.apk
echo.
echo ### 所有工作完成！ ###
echo.
pause
echo.


