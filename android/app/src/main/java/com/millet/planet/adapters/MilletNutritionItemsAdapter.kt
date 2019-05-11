package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import android.widget.LinearLayout
import android.widget.TextView
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.MilletNutritionData
import com.millet.planet.models.NutritionData
import kotlinx.android.synthetic.main.nutrition_item.view.*
import org.json.JSONObject

class MilletNutritionItemsAdapter(private val context: Context, private val myDataset: ArrayList<MilletNutritionData>) :
    RecyclerView.Adapter<MilletNutritionItemsAdapter.NutritionViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): NutritionViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.nutrition_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return NutritionViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: NutritionViewHolder, position: Int) {

        var data : MilletNutritionData = myDataset.get(position)

        holder?.itemName?.text = Html.fromHtml(data.name, null, MyTagHandler())
        holder?.scientificName?.text = Html.fromHtml(data.scientific_name, null, MyTagHandler())

        initWebView(holder?.typeDescription)
        holder?.typeDescription.loadData(data.millet_type, "text/html; charset=UTF-8", null)

        initWebView(holder?.description)
        holder?.description.loadData(data.description, "text/html; charset=UTF-8", null)

        initWebView(holder?.usesDescription)
        holder?.usesDescription.loadData(data.uses, "text/html; charset=UTF-8", null)

        initWebView(holder?.alternativeNamesDescription)
        holder?.alternativeNamesDescription.loadData(data.alternative_names, "text/html; charset=UTF-8", null)


        if(data.description == null || data.description.isEmpty()) {
            holder?.protocolLayout.visibility = View.GONE
        } else {
            holder?.protocolLayout.visibility = View.VISIBLE
        }

        if(data.uses == null || data.uses.isEmpty()) {
            holder?.usesLayout.visibility = View.GONE
        } else {
            holder?.usesLayout.visibility = View.VISIBLE
        }

        if(data.alternative_names == null || data.alternative_names.isEmpty()) {
            holder?.alternativeNamesLayout.visibility = View.GONE
        } else {
            holder?.alternativeNamesLayout.visibility = View.VISIBLE
        }

        var nutritionjsonString : String = data.nutrition.replace("\r\n", "")
        nutritionjsonString = nutritionjsonString.replace("o\"", "\"")
        nutritionjsonString = nutritionjsonString.replace("\\\"", "\"")

        println("nutritionjsonString $nutritionjsonString")

        val rootObject= JSONObject(nutritionjsonString)

        addDataToView(rootObject, holder?.nutritionLayout)

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

    private fun addDataToView(rootObject: JSONObject, nutritionLayout: LinearLayout) {
        val nutritionArray = ArrayList<NutritionData>()

        val iterator : Iterator<String> = rootObject.keys()

        while (iterator.hasNext()) {
            val key: String = iterator.next()
            val data = NutritionData()
            data.name = key
            data.value = rootObject.getString(key)

            nutritionArray.add(data)
        }

        setUpView(nutritionArray, nutritionLayout)
    }

    private fun setUpView(
        nutritionArray: ArrayList<NutritionData>,
        nutritionLayout: LinearLayout
    ) {

        nutritionLayout.removeAllViews()

        for (i in 0 until nutritionArray.size) {
            val view = LayoutInflater.from(context)
                .inflate(R.layout.nutrition_values_layout, null, false) as View

            val nameTv = view.findViewById(R.id.nutritionName) as TextView
            nameTv.text = nutritionArray.get(i).name

            val valueTv = view.findViewById(R.id.nutritionValue) as TextView
            valueTv.text = nutritionArray.get(i).value

            nutritionLayout.addView(view)
        }
    }

    class NutritionViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val itemName = itemView.itemName
        val scientificName = itemView.scientificName
        val typeDescription = itemView.typeDescription
        val description = itemView.description
        val viewMoreCB = itemView.viewMoreCB
        val moreOptionsLayout = itemView.moreOptionsLayout
        val nutritionLayout = itemView.nutritionLayout
        val usesDescription = itemView.usesDescription
        val protocolLayout = itemView.protocolLayout
        val usesLayout = itemView.usesLayout
        val alternativeNamesLayout = itemView.alternativeNamesLayout
        val alternativeNamesDescription = itemView.alternativeNamesDescription
    }

    private fun initWebView(webview: WebView) {
        webview?.getSettings().setJavaScriptEnabled(true)
        webview?.getSettings().setPluginState(WebSettings.PluginState.ON)
        webview?.getSettings().setJavaScriptCanOpenWindowsAutomatically(true)
        webview?.getSettings().setSupportMultipleWindows(true)
        webview?.getSettings().setAllowFileAccess(true)
    }

}

