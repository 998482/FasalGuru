allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Dynamic per-module JVM alignment: read EACH module's own Java
// compileOptions and make ITS Kotlin tasks match ONLY that module's target.
// Different plugins use different Java versions (tflite_flutter/geolocator
// = 11, app/firebase_storage = 17) — forcing one fixed number (e.g. 17) on
// every module causes "Inconsistent JVM Target Compatibility" for modules
// still on 11. Reading it per-module and matching it per-module fixes that.
// Uses gradle.projectsEvaluated (fires after ALL projects are evaluated,
// including :app which is evaluated early via evaluationDependsOn) so it
// never hits "Cannot run afterEvaluate when project is already evaluated".
gradle.projectsEvaluated {
    subprojects {
        val androidExt = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        val targetCompat = androidExt?.compileOptions?.targetCompatibility?.toString()
        if (targetCompat != null) {
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.fromTarget(targetCompat))
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}