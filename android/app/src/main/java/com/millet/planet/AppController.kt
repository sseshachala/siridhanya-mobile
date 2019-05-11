package com.millet.planet

import android.app.Application
import com.android.volley.Request
import com.android.volley.RequestQueue
import com.android.volley.toolbox.Volley

class AppController : Application() {
    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    val requestQueue : RequestQueue? = null
        get() {
            if (field == null) {
                return Volley.newRequestQueue(applicationContext)
            }
            return field
        }

    fun <T> addToRequestQueue(request: Request<T>) {
        request.tag = TAG
        requestQueue?.add(request)
    }

    companion object {
        private val TAG = AppController::class.java.simpleName
        @get:Synchronized var instance: AppController? = null
            private set
    }
}