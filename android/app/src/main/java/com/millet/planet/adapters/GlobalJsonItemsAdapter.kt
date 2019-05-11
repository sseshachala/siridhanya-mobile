package com.millet.planet.adapters

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.GlobalJsonData
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.global_json_item.view.*


class GlobalJsonItemsAdapter(private val context: Context, private var myDataset: ArrayList<GlobalJsonData>) :
    RecyclerView.Adapter<GlobalJsonItemsAdapter.GlobalJsonViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): GlobalJsonViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.global_json_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return GlobalJsonViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: GlobalJsonViewHolder, position: Int) {

        var data : GlobalJsonData = myDataset.get(position)

        holder?.itemName?.text = Html.fromHtml(data.name, null, MyTagHandler())

        initWebView(holder?.description)
        holder?.description.loadData(data.description, "text/html; charset=UTF-8", null)

        holder?.moreInfoLink?.text =  Html.fromHtml("<u>Video</u>")// Html.fromHtml(data.video_url)
        holder?.authorName.text = Html.fromHtml(data.author)

        if(data.video_url == null || data.video_url.isEmpty()) {
            holder?.morInfoLayout.visibility = View.GONE
        } else {
            holder?.morInfoLayout.visibility = View.VISIBLE
        }

        if(data.author == null || data.author.isEmpty()) {
            holder?.authorLayout.visibility = View.GONE
        } else {
            holder?.authorLayout.visibility = View.VISIBLE
        }

        if(data.image == null || data.image.isEmpty()) {
            holder.imageLayout?.visibility = View.GONE
        } else {
            holder.imageLayout?.visibility = View.VISIBLE
            Picasso.with(context).load(data.image).into(holder?.sourceId)
        }

        holder?.moreInfoLink?.setOnClickListener(View.OnClickListener {
            openDefaultBrowser(data.video_url)
        })

        holder?.authorName?.setOnClickListener(View.OnClickListener {
            emailToAuthor(data.email)
        })

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

    class GlobalJsonViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val itemName = itemView.itemName
        val description = itemView.description
        val moreInfoLink = itemView.moreInfoLink
        val viewMoreCB = itemView.viewMoreCB
        val moreOptionsLayout = itemView.moreOptionsLayout
        val morInfoLayout = itemView.morInfoLayout
        val authorLayout = itemView.authorLayout
        val authorName = itemView.authorName
        val sourceId = itemView.sourceId
        val imageLayout = itemView.imageLayout
    }

     fun sendData(faqMainArray: java.util.ArrayList<GlobalJsonData>) {
        myDataset = faqMainArray
        notifyDataSetChanged()
    }

    private fun openDefaultBrowser(service_name: String) {
        val openURL = Intent(Intent.ACTION_VIEW)
        openURL.data = Uri.parse(service_name)
        context.startActivity(openURL)
    }

    private fun emailToAuthor(email : String) {
        val emailIntent = Intent(Intent.ACTION_SENDTO)
        emailIntent.data = Uri.parse("mailto:$email")
        context.startActivity(Intent.createChooser(emailIntent, "Email to author"))
    }

    private fun initWebView(webview: WebView) {
        webview?.getSettings().setJavaScriptEnabled(true)
        webview?.getSettings().setPluginState(WebSettings.PluginState.ON)
        webview?.getSettings().setJavaScriptCanOpenWindowsAutomatically(true)
        webview?.getSettings().setSupportMultipleWindows(true)
        webview?.getSettings().setAllowFileAccess(true)
    }

}

