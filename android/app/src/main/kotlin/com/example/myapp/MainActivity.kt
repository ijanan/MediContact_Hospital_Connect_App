package com.example.myapp

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		// Allow screenshots. If any dependency sets FLAG_SECURE, clear it.
		window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
	}

	override fun onResume() {
		super.onResume()
		// Some SDKs/plugins may re-apply FLAG_SECURE on resume.
		window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
	}
}
