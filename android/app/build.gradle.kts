plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.myapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Workaround: When this project lives under OneDrive, some Flutter build artifacts
// (like build/.../.last_build_id or shaders) may be created as a reparse point.
// Gradle 8+ then fails while snapshotting task outputs. Disable state tracking for
// the Flutter build/asset tasks as recommended by Gradle in the error message.
tasks.matching { it.name.contains("Flutter") }.configureEach {
    doNotTrackState("OneDrive reparse-point build artifacts are not snapshot-friendly")
}
dependencies {

  // Import the Firebase BoM

  implementation(platform("com.google.firebase:firebase-bom:33.12.0"))

  // TODO: Add the dependencies for Firebase products you want to use

  // When using the BoM, don't specify versions in Firebase dependencies

  // https://firebase.google.com/docs/android/setup#available-libraries

}
