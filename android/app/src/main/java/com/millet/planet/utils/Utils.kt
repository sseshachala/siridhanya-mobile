package com.millet.planet.utils

import android.app.Activity
import android.content.Context
import android.graphics.Typeface
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import com.millet.planet.R

class Utils {

    companion object {
        fun installFonts(context: Context) : Void? {
            if (Constants.FONT_BOLD == null) {
                Constants.FONT_BOLD = Typeface.createFromAsset(context.assets, "fonts/Roboto-BoldCondensed.ttf")
            }
            if (Constants.FONT_MEDIUM == null) {
                Constants.FONT_MEDIUM = Typeface.createFromAsset(context.assets, "fonts/Roboto-Medium.ttf")
            }
            if (Constants.FONT_REGULAR == null) {
                Constants.FONT_REGULAR = Typeface.createFromAsset(context.assets, "fonts/Roboto-Regular.ttf")
            }
            return null
        }

        /**
         * this functiona is used to display error or success messages in the app.
         * @param _activity
         * @param toastMsg
         * @param backgroundDrawable
         */
        fun showCustomToast(_activity: Activity, toastMsg: String, backgroundDrawable: Int) {
            try {
                val inflater = fromContext(_activity)
                val layout: View
                if (inflater != null) {
                    layout = inflater!!.inflate(
                        R.layout.custom_toast,
                        _activity.findViewById(R.id.custom_toast_layout_id) as ViewGroup
                    )
                    val background = layout.findViewById(R.id.custom_toast_layout_id) as LinearLayout
                    background.setBackgroundResource(backgroundDrawable)

                    val tv = layout.findViewById(R.id.text) as TextView
                    // The actual toast generated here.
                    val toast = Toast(_activity)
                    tv.text = toastMsg
                    toast.duration = Toast.LENGTH_SHORT
                    toast.view = layout
                    toast.show()
                } else {
                    Toast.makeText(_activity, "" + toastMsg, Toast.LENGTH_SHORT).show()
                }
            } catch (e: AssertionError) {
                Log.w("HARI-->DEBUG", e)
                Toast.makeText(_activity, "" + toastMsg, Toast.LENGTH_SHORT).show()
            } catch (e: Exception) {
                Log.w("HARI-->DEBUG", e)
                Toast.makeText(_activity, "" + toastMsg, Toast.LENGTH_SHORT).show()
            }

        }

        /**
         * Obtains the LayoutInflater from the given context.
         */
        private fun fromContext(context: Context?): LayoutInflater? {
            var layoutInflater: LayoutInflater? = null
            try {
                if (context != null) {
                    layoutInflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
                }

                if (layoutInflater == null) {
                    throw AssertionError("LayoutInflater not found.")
                }
            } catch (e: Exception) {
                Log.w("HARI-->DEBUG", e)
                layoutInflater = null
            }

            return layoutInflater
        }
    }

}