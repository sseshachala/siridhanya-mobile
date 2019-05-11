package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import android.widget.Filter
import android.widget.Filterable
import com.android.volley.AuthFailureError
import com.millet.planet.R
import kotlin.collections.ArrayList
import com.android.volley.toolbox.RequestFuture
import com.android.volley.Request
import com.android.volley.toolbox.StringRequest
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.millet.planet.AppController
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.GenericSearchData
import kotlinx.android.synthetic.main.disease_item.view.itemName
import kotlinx.android.synthetic.main.disease_item.view.moreOptionsLayout
import kotlinx.android.synthetic.main.disease_item.view.protocolDescription
import kotlinx.android.synthetic.main.disease_item.view.viewMoreCB
import kotlinx.android.synthetic.main.generic_search_item.view.*
import java.util.concurrent.TimeUnit
import java.util.concurrent.ExecutionException
import java.util.concurrent.TimeoutException


class GenericSearchItemsAdapter(private val context: Context, private var myDataset: ArrayList<GenericSearchData>,
                                private val apiURL : String) :
    RecyclerView.Adapter<GenericSearchItemsAdapter.DiseaseDietViewHolder>(), Filterable {



    var arraylist: ArrayList<GenericSearchData> = ArrayList(myDataset)

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): DiseaseDietViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.generic_search_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return DiseaseDietViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: DiseaseDietViewHolder, position: Int) {

        var data : GenericSearchData = myDataset.get(position)

        holder?.itemName?.text = Html.fromHtml(data.Type_of_Ailment, null, MyTagHandler())


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
        val protocolDescription = itemView.protocolDescription
        val viewMoreCB = itemView.viewMoreCB
        val moreOptionsLayout = itemView.moreOptionsLayout
        val dietDescription = itemView.dietDescription
        val keywordsDescription = itemView.keywordsDescription
        val keywordLayout = itemView.keywordLayout
    }


    override fun getFilter(): Filter {

        return object : Filter() {
            override fun performFiltering(charSequence: CharSequence): Filter.FilterResults {
                myDataset.clear()
                val charString = charSequence.toString()
                if (charString.isEmpty()) {
                    myDataset.addAll(arraylist)
                } else {
                    val future = RequestFuture.newFuture<String>()

                    val stringRequest = object : StringRequest(Request.Method.POST,
                        apiURL, future, future){

                        @Throws(AuthFailureError::class)
                        override fun getParams(): Map<String, String> {
                            val params = HashMap<String, String>()
                            params.put("searchTerm", charString)
                            return params
                        }
                    }

                    AppController.instance?.addToRequestQueue(stringRequest)

                    try {

                        val response = future.get(30, TimeUnit.SECONDS)

                        val gson = Gson()
                        val listType = object : TypeToken<java.util.ArrayList<GenericSearchData>>() {}.type
                        val filteredList: java.util.ArrayList<GenericSearchData> = gson.fromJson(response, listType)

                        myDataset = filteredList

                    } catch (e: InterruptedException) {
                        // exception handling
                    } catch (e: ExecutionException) {
                        // exception handling
                    } catch (e: TimeoutException) {
                        // exception handling
                    }

                }

                val filterResults = Filter.FilterResults()
                filterResults.values = myDataset
                return filterResults
            }

            override fun publishResults(charSequence: CharSequence, filterResults: Filter.FilterResults) {
                myDataset = filterResults.values as ArrayList<GenericSearchData>
                notifyDataSetChanged()
            }
        }
    }


}

