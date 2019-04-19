package com.millet.planet.listeners


interface VolleyCallback {
    fun onVolleySuccess(response: String, requestNumber: Int)
    fun onVolleyError(error: String?)
}