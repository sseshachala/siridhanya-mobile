package com.millet.planet.customViews.textviews

import android.content.Context
import android.util.AttributeSet
import android.widget.TextView
import com.millet.planet.utils.Constants
import com.millet.planet.utils.Utils

class RegularTextView: TextView {
    constructor(context: Context) : this(context, null)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        applyFonts(context)
    }

    fun applyFonts(context: Context) {
        if (Constants.FONT_REGULAR != null) run { typeface = Constants.FONT_REGULAR }
        else run {
            Utils.installFonts(context)
            typeface = Constants.FONT_REGULAR
            println("Oxigen ligh tnot loaded")
        }
    }
}