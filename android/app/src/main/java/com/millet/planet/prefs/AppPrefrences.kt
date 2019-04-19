package com.millet.planet.prefs

import android.content.Context
import android.content.SharedPreferences

class AppPrefrences (context: Context) {
    private var PRIVATE_MODE = 0
    private val PREF_NAME = "Millet_Planet"


    val sharedPref: SharedPreferences = context.getSharedPreferences(PREF_NAME, PRIVATE_MODE)

    fun saveDashboardData (data: String) {
        val editor = sharedPref.edit()
        editor.putString("dashBoardData", data)
        editor.apply()
    }

    fun getDashBoardData() : String? {
        return sharedPref.getString("dashBoardData", "")
    }
}