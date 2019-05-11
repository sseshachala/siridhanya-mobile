package com.millet.planet

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.SearchView
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import com.millet.planet.adapters.GenericSearchItemsAdapter
import com.millet.planet.models.GenericSearchData
import kotlinx.android.synthetic.main.activity_generic_search.backToDashboard
import kotlinx.android.synthetic.main.activity_generic_search.dataSearchView
import kotlinx.android.synthetic.main.activity_generic_search.recyclerView


class GenericSearchActivity : AppCompatActivity(), SearchView.OnQueryTextListener  {

    lateinit var searchAdapter: GenericSearchItemsAdapter

    lateinit var layoutManagerMain: LinearLayoutManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_generic_search)

        val i = intent

        var apiURL = i.getStringExtra("api")

        backToDashboard.setOnClickListener {
            finish()
        }

        layoutManagerMain = LinearLayoutManager(this)
        recyclerView.layoutManager = layoutManagerMain
        recyclerView.setHasFixedSize(true)

        /*Code for changing the search icon */
        val searchIcon = dataSearchView.findViewById(android.support.v7.appcompat.R.id.search_button) as ImageView
        searchIcon.setImageResource(R.drawable.search)

        val closeIcon = dataSearchView.findViewById(android.support.v7.appcompat.R.id.search_close_btn) as ImageView
        closeIcon.setImageResource(R.drawable.close)

        closeIcon.setOnClickListener(View.OnClickListener {
            if(dataSearchView.query.isEmpty()) {

            } else {
                dataSearchView.setQuery("", true)
            }
        })

        val searchEditText = dataSearchView.findViewById(android.support.v7.appcompat.R.id.search_src_text) as EditText
        searchEditText.setTextColor(resources.getColor(R.color.white))
        searchEditText.setHintTextColor(resources.getColor(R.color.white))

        dataSearchView.setOnQueryTextListener(this)

        dataSearchView.setIconifiedByDefault(false)
        dataSearchView.queryHint = "Search Here.."

        searchAdapter = GenericSearchItemsAdapter(this, ArrayList<GenericSearchData>(), apiURL)
        recyclerView.adapter = searchAdapter

    }

    override fun onQueryTextSubmit(query: String?): Boolean {

        return true
    }

    override fun onQueryTextChange(newText: String?): Boolean {

        val text = newText
        text?.let { searchAdapter.filter.filter(it) }

        return false
    }

}
