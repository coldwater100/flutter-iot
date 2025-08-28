plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_app_android"
    compileSdk = flutter.compileSdkVersion

    // ✅ NDK 버전 강제 (플러그인 요구사항 맞춤)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_app_android"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // ✅ 코드 난독화 & 리소스 최적화
            isMinifyEnabled = true
            isShrinkResources = true

            // ✅ ProGuard 규칙 파일 적용
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // ✅ 스토어 배포 전까진 debug 서명 사용 가능
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("debug") {
            // debug 빌드는 난독화 X
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
