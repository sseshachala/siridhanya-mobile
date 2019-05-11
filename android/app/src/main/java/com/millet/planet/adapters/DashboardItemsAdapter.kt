package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.millet.planet.R
import com.millet.planet.adapters.DashboardItemsAdapter.DashboardViewHolder
import com.millet.planet.models.DashBoardData
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.dashboard_item.view.*

class DashboardItemsAdapter(private val context: Context, private var myDataset: ArrayList<DashBoardData>) :
    RecyclerView.Adapter<DashboardViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): DashboardViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.dashboard_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return DashboardViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: DashboardViewHolder, position: Int) {
        holder?.itemTitle?.text = myDataset.get(position).menu_name

        if(myDataset.get(position).icon != "") {
            holder?.itemImage.scaleType = ImageView.ScaleType.CENTER_CROP
            Picasso.with(context).load(myDataset.get(position).icon).into(holder?.itemImage)
        }
    }

    fun setItems(dashboardArray: ArrayList<DashBoardData>) {
        myDataset = dashboardArray
        notifyDataSetChanged()
    }

    class DashboardViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        val itemImage = itemView.itemImage
        val itemTitle = itemView.itemTitle
    }

}

