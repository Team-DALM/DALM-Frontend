import java.util.Properties
import java.net.URI

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val dalmEnvironment = Properties().apply {
    val environmentFile = rootProject.file("../.env")

    if (!environmentFile.exists()) {
        throw GradleException("frontend/.env 파일이 없습니다.")
    }

    environmentFile.inputStream().use { load(it) }
}

val kakaoNativeAppKey = dalmEnvironment.getProperty("KAKAO_NATIVE_APP_KEY")
    ?.trim()
    ?.takeIf { it.isNotEmpty() }
    ?: throw GradleException("KAKAO_NATIVE_APP_KEY가 설정되지 않았습니다.")

val apiBaseUrl = dalmEnvironment.getProperty("API_BASE_URL")?.trim()
    ?: throw GradleException("API_BASE_URL이 설정되지 않았습니다.")
val apiUri = URI(apiBaseUrl)
val httpApiHost = if (apiUri.scheme == "http") apiUri.host
    ?: throw GradleException("HTTP API host is missing") else ""
val networkSecurityResources = layout.buildDirectory.dir("generated/dalmNetworkSecurity/res")
val generateDalmNetworkSecurity = tasks.register("generateDalmNetworkSecurity") {
    inputs.property("httpApiHost", httpApiHost)
    outputs.dir(networkSecurityResources)
    doLast {
        val output = networkSecurityResources.get().file("xml/dalm_network_security_config.xml").asFile
        output.parentFile.mkdirs()
        val exception = if (httpApiHost.isEmpty()) "" else
            "<domain-config cleartextTrafficPermitted=\"true\"><domain includeSubdomains=\"false\">$httpApiHost</domain></domain-config>"
        output.writeText("<network-security-config><base-config cleartextTrafficPermitted=\"false\"/>$exception</network-security-config>")
    }
}
tasks.named("preBuild").configure { dependsOn(generateDalmNetworkSecurity) }

android {
    namespace = "com.goodshot.dalm"
    sourceSets.getByName("main").res.srcDir(networkSecurityResources.get().asFile)
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.goodshot.dalm"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["KAKAO_NATIVE_APP_KEY"] = kakaoNativeAppKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
