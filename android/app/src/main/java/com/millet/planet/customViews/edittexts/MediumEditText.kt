package com.millet.planet.customViews.edittexts

import android.content.Context
import android.util.AttributeSet
import android.widget.EditText
import com.millet.planet.utils.Constants
import com.millet.planet.utils.Utils

class MediumEditText: EditText {
    constructor(context: Context) : this(context, null)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        applyFonts(context)
    }

    fun applyFonts(context: Context) {
        if (Constants.FONT_MEDIUM != null) run { typeface = Constants.FONT_MEDIUM }
        else run {
            Utils.installFonts(context)
            typeface = Constants.FONT_MEDIUM
            println("Oxigen ligh tnot loaded")
        }
    }
}