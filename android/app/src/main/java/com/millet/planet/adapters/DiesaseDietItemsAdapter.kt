package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.MilletDiseasesDietData
import kotlinx.android.synthetic.main.disease_item.view.*


class DiesaseDietItemsAdapter(private val context: Context, private val myDataset: ArrayList<MilletDiseasesDietData>) :
    RecyclerView.Adapter<DiesaseDietItemsAdapter.DiseaseDietViewHolder>() {

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

        holder?.itemName?.text = data.disease_name
        holder?.juiceDescription?.text =  Html.fromHtml(data.dictoction_kashayas_juice, null, MyTagHandler())
        holder?.protocolDescription?.text =  Html.fromHtml(data.milletProtocol, null, MyTagHandler())

        if(data.specialInstruction == null || data.specialInstruction.isEmpty()) {
            holder?.instructionLayout.visibility = View.GONE
        } else {
            holder?.instructionLayout.visibility = View.VISIBLE
            holder?.instructionDescription.text = Html.fromHtml(data.specialInstruction)
        }

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

    class DiseaseDietViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val itemName = itemView.itemName
        val juiceDescription = itemView.juiceDescription
        val protocolDescription = itemView.protocolDescription
        val viewMoreCB = itemView.viewMoreCB
        val moreOptionsLayout = itemView.moreOptionsLayout
        val instructionDescription = itemView.instructionDescription
        val instructionLayout = itemView.instructionLayout
    }

}

