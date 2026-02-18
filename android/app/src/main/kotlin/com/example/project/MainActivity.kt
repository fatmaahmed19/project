package com.example.project // Keep your original package name here

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // This line manually registers all your plugins (like Firebase) 
        // to the Android engine to prevent the "channel-error"
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}