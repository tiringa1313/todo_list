android {
    namespace = "com.example.todo_list_provider"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Recomendado com AGP 8+: use Java 17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.todo_list_provider"

        // >>> AQUI ESTÁ O FIX <<<
        minSdk = 23   // antes: flutter.minSdkVersion (geralmente 21)

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

dependencies {
    // BoM do Firebase
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))

    // Produtos Firebase (adicione os que usar)
    implementation("com.google.firebase:firebase-analytics")
}
