package com.millet.planet.customViews.textviews

import org.xml.sax.XMLReader

import android.text.Editable
import android.text.Html.TagHandler

class MyTagHandler : TagHandler {
    internal var first = true
    internal var parent: String? = null
    internal var index = 1
    override fun handleTag(
        opening: Boolean, tag: String, output: Editable,
        xmlReader: XMLReader
    ) {

        if (tag == "ul")
            parent = "ul"
        else if (tag == "ol") parent = "ol"
        if (tag == "li") {
            if (parent == "ul") {
                if (first) {
                    output.append("\n\t•")
                    first = false
                } else {
                    first = true
                }
            } else {
                if (first) {
                    output.append("\n\t$index. ")
                    first = false
                    index++
                } else {
                    first = true
                }
            }
        }
    }
}