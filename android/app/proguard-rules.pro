# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# TFLite
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.**

# App models (Firestore reflection safety)
-keep class com.fasalguru.app.** { *; }

# Annotations
-keepattributes *Annotation*
-keepattributes Signature
-dontwarn kotlin.**

# Room/Floor database
-keep class * extends androidx.room.RoomDatabase { *; }
-keep @androidx.room.Entity class * { *; }

# Play Core
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**