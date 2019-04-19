package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
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
        holder?.itemNote?.text = Html.fromHtml(myDataset.get(position).Description, null, MyTagHandler())
        holder?.itemCount?.text =  ((position + 1) as Int).toString()
    }

    fun sendData(lifestyleArray: java.util.ArrayList<LifestyleData>) {
        myDataset = lifestyleArray
        notifyDataSetChanged()
    }

    class LifestyleViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        val itemCount = itemView.itemCount
        val itemNote = itemView.itemNote
    }

}

