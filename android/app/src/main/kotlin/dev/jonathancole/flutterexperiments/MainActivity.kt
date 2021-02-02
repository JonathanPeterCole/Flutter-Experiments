package dev.jonathancole.flutterexperiments

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Draw behind the navigation bar on Android SDK 30+
        // https://github.com/flutter/flutter/issues/69999
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
        }
    }
}