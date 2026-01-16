import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // REMOVED: id("kotlin-android") <- This plugin is removed for AGP 9+ migration
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
            val keystoreAlias = (keystoreProperties["keyAlias"] as? String) 
                ?: System.getenv("KEY_ALIAS")
            val keystorePass = (keystoreProperties["keyPassword"] as? String) 
                ?: System.getenv("KEY_PASSWORD")
            val keystoreFile = (keystoreProperties["storeFile"] as? String) 
                ?: System.getenv("STORE_FILE")
            val keystoreStorePass = (keystoreProperties["storePassword"] as? String) 
                ?: System.getenv("STORE_PASSWORD")

            if (keystoreAlias != null && keystorePass != null && keystoreFile != null && keystoreStorePass != null) {
                keyAlias = keystoreAlias
                keyPassword = keystorePass
                storeFile = if (keystoreFile.startsWith("/")) file(keystoreFile) else rootProject.file(keystoreFile)
                storePassword = keystoreStorePass
            } else {
                println("Release signing configuration not found. Release build will NOT be signed.")
            }
        }
    }

    buildTypes {
        release {
            // FIX: Only apply the signing config if the storeFile is actually set.
            // This prevents the NullPointerException when keys are missing.
            val config = signingConfigs.getByName("release")
            if (config.storeFile != null) {
                signingConfig = config
            }
        }
    }
}

flutter {
    source = "../.."
}