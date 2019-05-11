package com.millet.planet.services

import android.content.Context
import com.android.volley.AuthFailureError
import com.android.volley.Response
import com.android.volley.VolleyError
import com.android.volley.toolbox.StringRequest
import com.millet.planet.AppController
import com.millet.planet.listeners.VolleyCallback
import com.android.volley.DefaultRetryPolicy



class ServiceManager {

    companion object {
        const val DASHBOARD_REQUEST_NUMBER : Int = 1
        const val MILLET_NUTRITION_REQUEST_NUMBER : Int = 2
        const val ABOUT_REQUEST_NUMBER : Int = 3
        const val KIDS_INSTRUCTION_REQUEST_NUMBER : Int = 4
        const val LIFESTYLE_REQUEST_NUMBER : Int = 5
        const val DISEASE_DIET_REQUEST_NUMBER : Int = 6
        const val CANCER_DIET_REQUEST_NUMBER : Int = 7
        const val FAQ_REQUEST_NUMBER : Int = 8
        const val GLOBAL_JSON_REQUEST_NUMBER : Int = 9
        const val USER_REGISTRATION_REQUEST_NUMBER : Int = 10

        fun makeStringRequest(context: Context, requestType: Int, callback: VolleyCallback, requestNumber: Int, url: String){

            val finalURL : String = url.replace(" ", "%20")

            val stringRequest = object : StringRequest(requestType, finalURL,
                Response.Listener<String> { response ->
                    try {
//                        val obj = JSONObject(response)
                        callback.onVolleySuccess(response, requestNumber)
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                },
                Response.ErrorListener { volleyError -> callback.onVolleyError(volleyError.message) })
            {
                @Throws(AuthFailureError::class)
                override fun getParams(): Map<String, String> {
                    val params = HashMap<String, String>()
                    return params
                }
            }

            val socketTimeout = 90000//30 seconds - change to what you want
            val policy = DefaultRetryPolicy(
                socketTimeout,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
            )
            stringRequest.retryPolicy = policy
            stringRequest.setShouldCache(false)

            //adding request to queue
            AppController.instance?.addToRequestQueue(stringRequest)
        }
    }

}