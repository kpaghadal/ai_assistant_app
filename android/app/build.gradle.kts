plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // apply here
   
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ai_assistant_app"
    compileSdk = 35
    ndkVersion = "29.0.14206865"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.ai_assistant_app"
        minSdk = 23
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ADD FIREBASE BoM
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // ADD FIREBASE PRODUCTS YOU USE
    implementation("com.google.firebase:firebase-analytics")

    // Example (add only if needed)
     implementation("com.google.firebase:firebase-auth")
     implementation("com.google.firebase:firebase-firestore")
    // implementation("com.google.firebase:firebase-storage")
    // implementation("com.google.firebase:firebase-messaging")
}
