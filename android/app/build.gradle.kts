import java.util.Properties
import java.io.FileInputStream



plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
var keystorePropertiesFile = rootProject.file("key.properties")

// Fallback mechanism to find key.properties if rootProject resolution fails
if (!keystorePropertiesFile.exists()) {
    // Try explicit path assuming we are in android/app and key.properties is in android/
    val altFile = file("../key.properties")
    if (altFile.exists()) {
        keystorePropertiesFile = altFile
        println("RELEASE SIGNING: Found key.properties at relative path: " + altFile.absolutePath)
    } else {
        println("RELEASE SIGNING: Could not find key.properties at " + keystorePropertiesFile.absolutePath + " or " + altFile.absolutePath)
    }
} else {
     println("RELEASE SIGNING: Found key.properties at " + keystorePropertiesFile.absolutePath)
}

if (keystorePropertiesFile.exists()) {
    try {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    } catch (e: Exception) {
        println("RELEASE SIGNING: Failed to load properties: " + e.message)
    }
}


android {
    namespace = "com.sarang.todo_app"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.sarang.todo_app"
        // You can update the following values to match your application needs.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyAliasStr = keystoreProperties.getProperty("keyAlias")
            val keyPasswordStr = keystoreProperties.getProperty("keyPassword")
            val storeFileStr = keystoreProperties.getProperty("storeFile")
            val storePasswordStr = keystoreProperties.getProperty("storePassword")

            if (keyAliasStr != null && keyPasswordStr != null && storeFileStr != null && storePasswordStr != null) {
                keyAlias = keyAliasStr
                keyPassword = keyPasswordStr
                storeFile = file(storeFileStr)
                storePassword = storePasswordStr
            } else {
                // Log missing keys for debugging (without revealing secrets)
                if (keystoreProperties.isEmpty) {
                    println("RELEASE SIGNING: Properties file is empty or not loaded.")
                } else {
                   println("RELEASE SIGNING: Missing specific keys.")
                   if (keyAliasStr == null) println("  - keyAlias is missing")
                   if (keyPasswordStr == null) println("  - keyPassword is missing")
                   if (storeFileStr == null) println("  - storeFile is missing")
                   if (storePasswordStr == null) println("  - storePassword is missing")
                }
                // Don't throw exception yet, to allow debug builds to proceed? 
                // But this is 'release' config.
                // If we are building release, we need this.
                // However, 'create("release")' is executed during configuration phase.
                // We shouldn't crash just because it's configured, only if used.
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
