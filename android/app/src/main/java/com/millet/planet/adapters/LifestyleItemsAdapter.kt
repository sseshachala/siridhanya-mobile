package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import com.millet.planet.R
import com.millet.planet.models.LifestyleData
import kotlinx.android.synthetic.main.global_item.view.*

class LifestyleItemsAdapter(private val context: Context, private var myDataset: ArrayList<LifestyleData>) :
    RecyclerView.Adapter<LifestyleItemsAdapter.LifestyleViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): LifestyleViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.global_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return LifestyleViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: LifestyleViewHolder, position: Int) {
        holder?.itemCount?.text =  ((position + 1) as Int).toString()

        initWebView(holder?.itemNote)
        holder?.itemNote.loadData(myDataset.get(position).Description, "text/html; charset=UTF-8", null)

    }

    fun sendData(lifestyleArray: java.util.ArrayList<LifestyleData>) {
        myDataset = lifestyleArray
        notifyDataSetChanged()
    }

    class LifestyleViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

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

