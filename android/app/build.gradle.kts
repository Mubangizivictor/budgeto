plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.budgeto.app"  // Changed from com.example.budgeto
    compileSdk = 34  // Set to 34 explicitly
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Update this to your unique Application ID
        applicationId = "com.budgeto.app"
        minSdk = 21  // Set minimum SDK to 21 (Android 5.0)
        targetSdk = 34  // Set target SDK to 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true  // Add this for large apps
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // For now, using debug signing (not for production!)
            signingConfig = signingConfigs.getByName("debug")

            // Add these for release optimization
            minifyEnabled = false
            shrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            // Debug specific settings
            minifyEnabled = false
            debuggable = true
        }
    }
}

flutter {
    source = "../.."
}

// Add this to handle large apps
dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}