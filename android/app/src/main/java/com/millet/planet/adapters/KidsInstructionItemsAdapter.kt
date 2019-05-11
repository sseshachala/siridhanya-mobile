package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.KidsInstructionData
import kotlinx.android.synthetic.main.global_item.view.*

class KidsInstructionItemsAdapter(private val context: Context, private var myDataset: ArrayList<KidsInstructionData>) :
    RecyclerView.Adapter<KidsInstructionItemsAdapter.KidsInstructionViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): KidsInstructionViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.global_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return KidsInstructionViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: KidsInstructionViewHolder, position: Int) {
        holder?.itemCount?.text = ((position + 1) as Int).toString()

        initWebView(holder?.itemNote)
        holder?.itemNote.loadData(myDataset.get(position).note, "text/html; charset=UTF-8", null)
    }

    fun sendData(kidsInstructionArray: java.util.ArrayList<KidsInstructionData>) {
        myDataset = kidsInstructionArray
        notifyDataSetChanged()
    }

    class KidsInstructionViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        val itemCount = itemView.itemCount
        val itemNote = itemView.itemNote
    }


    private fun initWebView(webview: WebView) {
        webview?.getSettings().setJavaScriptEnabled(true)
        webview?.getSettings().setPluginState(WebSettings.PluginState.ON)
        webview?.getSettings().setJavaScriptCanOpenWindowsAutomatically(true)
        webview?.getSettings().setSupportMultipleWindows(true)
        webview?.getSettings().setAllowFileAccess(true)
    }


}

