import java.util.Properties
import java.io.FileInputStream



plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.salih.cicdSample"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
        }
    }

    defaultConfig {
        applicationId = "com.salih.cicdSample"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Try to get secrets from key.properties, otherwise fallback to Environment Variables
            val keystoreAlias = (keystoreProperties["keyAlias"] as? String) 
                ?: System.getenv("KEY_ALIAS")
            
            val keystorePass = (keystoreProperties["keyPassword"] as? String) 
                ?: System.getenv("KEY_PASSWORD")
            
            val keystoreFile = (keystoreProperties["storeFile"] as? String) 
                ?: System.getenv("STORE_FILE")
            
            val keystoreStorePass = (keystoreProperties["storePassword"] as? String) 
                ?: System.getenv("STORE_PASSWORD")

            // Only configure signing if we found the credentials
            if (keystoreAlias != null && keystorePass != null && keystoreFile != null && keystoreStorePass != null) {
                keyAlias = keystoreAlias
                keyPassword = keystorePass
                storeFile = file(keystoreFile)
                storePassword = keystoreStorePass
            } else {
                println("Release signing configuration not found. Skipping signing.")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
