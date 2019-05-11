package com.millet.planet.customViews.textviews

import android.graphics.drawable.Drawable
import android.graphics.drawable.BitmapDrawable
import com.squareup.picasso.Picasso
import android.graphics.Bitmap
import android.content.Context
import android.graphics.Canvas
import android.text.Html
import android.widget.TextView
import com.millet.planet.R
import com.squareup.picasso.Target


class PicassoImageGetter : Html.ImageGetter {

    private var textView: TextView? = null
    private var mContext: Context? = null

    constructor(target: TextView, context: Context) {
        textView = target
        mContext = context
    }

    override fun getDrawable(source: String): Drawable {
        val drawable = BitmapDrawablePlaceHolder()
        Picasso.with(mContext)
            .load(source)
            .placeholder(R.mipmap.small_logo)
            .into(drawable)
        return drawable
    }

    private inner class BitmapDrawablePlaceHolder : BitmapDrawable(), Target {

        var mdrawable: Drawable? = null

        override fun draw(canvas: Canvas) {
            if (mdrawable != null) {
                mdrawable!!.draw(canvas)
            }
        }

        fun setDrawable(drawable: Drawable) {
            this.mdrawable = drawable
            val width = drawable.intrinsicWidth
            val height = drawable.intrinsicHeight
            drawable.setBounds(0, 0, width, height)
            setBounds(0, 0, width, height)
            if (textView != null) {
                textView!!.setText(textView!!.getText())
            }
        }

        override fun onBitmapLoaded(bitmap: Bitmap, from: Picasso.LoadedFrom) {
            setDrawable(BitmapDrawable(mContext!!.getResources(), bitmap))
        }

        override fun onBitmapFailed(errorDrawable: Drawable) {}

        override fun onPrepareLoad(placeHolderDrawable: Drawable) {

        }

    }
}