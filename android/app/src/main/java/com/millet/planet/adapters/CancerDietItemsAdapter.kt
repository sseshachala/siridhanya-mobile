package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.MilletCancerDietData
import kotlinx.android.synthetic.main.cancer_item.view.*

class CancerDietItemsAdapter(private val context: Context, private val myDataset: ArrayList<MilletCancerDietData>) :
    RecyclerView.Adapter<CancerDietItemsAdapter.CancerDietViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): CancerDietViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.cancer_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return CancerDietViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: CancerDietViewHolder, position: Int) {

        var data : MilletCancerDietData = myDataset.get(position)

        holder?.itemName?.text = data.cancer_type
        holder?.juiceDescription?.text =  Html.fromHtml(data.dictoction_kashayas_juice_every_week, null, MyTagHandler())
        holder?.protocolDescription?.text =  Html.fromHtml(data.milletProtocol, null, MyTagHandler())
        holder?.juiceDescription2.text = Html.fromHtml(data.dictoction_kashayas_juice_afternoon_each_week, null, MyTagHandler())

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

    class CancerDietViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val itemName = itemView.itemName
        val juiceDescription = itemView.juiceDescription
        val protocolDescription = itemView.protocolDescription
        val viewMoreCB = itemView.viewMoreCB
        val moreOptionsLayout = itemView.moreOptionsLayout
        val juiceDescription2 = itemView.juiceDescription2
    }

}

