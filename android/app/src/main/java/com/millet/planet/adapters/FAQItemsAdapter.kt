package com.millet.planet.adapters

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.millet.planet.ListViewActivity
import com.millet.planet.R
import com.millet.planet.customViews.textviews.MyTagHandler
import com.millet.planet.models.FAQData
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.faq_item.view.*

class FAQItemsAdapter(private val context: Context, private var myDataset: ArrayList<FAQData>) :
    RecyclerView.Adapter<FAQItemsAdapter.FAQViewHolder>() {

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): FAQViewHolder {
        // create a new view
        val view = LayoutInflater.from(p0.context)
            .inflate(R.layout.faq_item, p0, false) as View
        // set the view's size, margins, paddings and layout parameters
        return FAQViewHolder(view)
    }

    override fun getItemCount(): Int = myDataset.size

    override fun onBindViewHolder(holder: FAQViewHolder, position: Int) {

        var data = myDataset.get(position)

        holder?.itemNote?.text = Html.fromHtml(data.question, null, MyTagHandler())
//        holder?.itemCount?.text = ((position + 1) as Int).toString()

        if(!data.question_icon.isEmpty()){
            Picasso.with(context).load(myDataset.get(position).question_icon).into(holder?.itemCount)
        }

        holder?.viewAnswerLayout.setOnClickListener(View.OnClickListener {
            (context as ListViewActivity).showQuestion(data)
        })
    }

    fun sendData(faqMainArray: java.util.ArrayList<FAQData>) {
        myDataset = faqMainArray
        notifyDataSetChanged()
    }

    class FAQViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        val itemCount = itemView.itemCount
        val itemNote = itemView.itemNote
        val viewAnswerLayout = itemView.viewAnswerLayout
    }

}

