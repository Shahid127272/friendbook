buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Gradle Plugin version match karo apne project se
        classpath("com.android.tools.build:gradle:8.1.2")

        // 🔥 YE SABSE IMPORTANT LINE
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
