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
        val DASHBOARD_REQUEST_NUMBER : Int = 1
        val MILLET_NUTRITION_REQUEST_NUMBER : Int = 2
        val ABOUT_REQUEST_NUMBER : Int = 3
        val KIDS_INSTRUCTION_REQUEST_NUMBER : Int = 4
        val LIFESTYLE_REQUEST_NUMBER : Int = 5
        val DISEASE_DIET_REQUEST_NUMBER : Int = 6
        val CANCER_DIET_REQUEST_NUMBER : Int = 7
        val FAQ_REQUEST_NUMBER : Int = 8
        val GLOBAL_JSON_REQUEST_NUMBER : Int = 9

        fun makeStringRequest(context: Context, requestType: Int, callback: VolleyCallback, requestNumber: Int, url: String){
            val stringRequest = object : StringRequest(requestType, url,
                Response.Listener<String> { response ->
                    try {
//                        val obj = JSONObject(response)
                        callback.onVolleySuccess(response, requestNumber)
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                },
                object : Response.ErrorListener {
                    override fun onErrorResponse(volleyError: VolleyError) {
                        callback.onVolleyError(volleyError.message)
                    }
                })
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
            stringRequest.setRetryPolicy(policy)
            stringRequest.setShouldCache(false)

            //adding request to queue
            AppController.instance?.addToRequestQueue(stringRequest)
        }
    }

}