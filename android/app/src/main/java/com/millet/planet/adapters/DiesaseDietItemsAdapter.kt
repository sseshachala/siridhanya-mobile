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
import com.millet.planet.models.MilletDiseasesDietData
import kotlinx.android.synthetic.main.disease_item.view.*
import kotlin.collections.ArrayList
import java.util.*

class DiesaseDietItemsAdapter(private val context: Context, private var myDataset: ArrayList<MilletDiseasesDietData>) :
    RecyclerView.Adapter<DiesaseDietItemsAdapter.DiseaseDietViewHolder>() {

    var arraylist: ArrayList<MilletDiseasesDietData> = ArrayList(myDataset)

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): DiseaseDietViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.disease_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return DiseaseDietViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: DiseaseDietViewHolder, position: Int) {

        var data : MilletDiseasesDietData = myDataset.get(position)

        holder?.itemName?.text = Html.fromHtml(data.Type_of_Ailment, null, MyTagHandler())

        if(data.description == null || data.description.isEmpty()) {
            holder?.descriptionLayout.visibility = View.GONE
        } else {
            holder?.descriptionLayout.visibility = View.VISIBLE
        }


        if(data.Tags_Keywords == null || data.Tags_Keywords.isEmpty()) {
            holder?.keywordLayout.visibility = View.GONE
        } else {
            holder?.keywordLayout.visibility = View.VISIBLE
        }


        initWebView(holder?.dietDescription)
        holder?.dietDescription.loadData(data.Dictoction_Kashayam_Diet, "text/html; charset=UTF-8", null)

        initWebView(holder?.protocolDescription)
        holder?.protocolDescription.loadData(data.milletProtocol, "text/html; charset=UTF-8", null)


        initWebView(holder?.keywordsDescription)
        holder?.keywordsDescription.loadData(data.Tags_Keywords, "text/html; charset=UTF-8", null)

        initWebView(holder?.description)
        holder?.description.loadData(data.description, "text/html; charset=UTF-8", null)

        holder?.viewMoreCB.setOnCheckedChangeListener(null)

        holder?.viewMoreCB.isChecked = data.expanded

        if(data.expanded) {
            holder?.moreOptionsLayout.visibility = View.VISIBLE
        } else {
            holder?.moreOptionsLayout.visibility = View.GONE
        }

        holder?.viewMoreCB.setOnCheckedChangeListener{ buttonView, isChecked ->
            if(isChecked) {
                holder?.moreOptionsLayout.visibility = View.VISIBLE
            } else {
                holder?.moreOptionsLayout.visibility = View.GONE
            }
            myDataset.get(position).expanded = isChecked
        }
    }

    private fun initWebView(webview: WebView) {
        webview?.getSettings().setJavaScriptEnabled(true)
        webview?.getSettings().setPluginState(WebSettings.PluginState.ON)
        webview?.getSettings().setJavaScriptCanOpenWindowsAutomatically(true)
        webview?.getSettings().setSupportMultipleWindows(true)
        webview?.getSettings().setAllowFileAccess(true)
    }

    class DiseaseDietViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val itemName = itemView.itemName
        val dietDescription = itemView.dietDescription
        val protocolDescription = itemView.protocolDescription
        val viewMoreCB = itemView.viewMoreCB
        val moreOptionsLayout = itemView.moreOptionsLayout
        val keywordLayout = itemView.keywordLayout
        val descriptionLayout = itemView.descriptionLayout
        val keywordsDescription = itemView.keywordsDescription
        val description = itemView.description
    }

    // Filter Class
    fun filter(charText: String) {
        var charText = charText
        charText = charText.toLowerCase(Locale.getDefault())
        myDataset.clear()
        if (charText.isEmpty()) {
            myDataset.addAll(arraylist)
        } else {
            for (wp in arraylist) {
                if (wp.Type_of_Ailment.toLowerCase(Locale.getDefault()).contains(charText)) {
                    myDataset.add(wp)
                }
            }
        }
        notifyDataSetChanged()
    }

}

