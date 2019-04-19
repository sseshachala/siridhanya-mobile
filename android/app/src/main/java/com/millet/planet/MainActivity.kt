package com.millet.planet

import android.content.Intent
import android.net.Uri
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.android.volley.Request
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.millet.planet.listeners.VolleyCallback
import com.millet.planet.models.DashBoardData
import com.millet.planet.services.ServiceManager
import com.millet.planet.utils.ApiUrls
import com.millet.planet.utils.Constants
import com.millet.planet.utils.Utils
import kotlinx.android.synthetic.main.activity_main.*
import android.support.v7.widget.GridLayoutManager
import android.view.View
import com.millet.planet.adapters.DashboardItemsAdapter
import com.millet.planet.listeners.RecyclerItemClickListener
import com.millet.planet.prefs.AppPrefrences


class MainActivity : AppCompatActivity(), VolleyCallback{

    private var dashboardArray: ArrayList<DashBoardData> = ArrayList()

    lateinit var viewAdapter: DashboardItemsAdapter

    lateinit var prefs : AppPrefrences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        prefs = AppPrefrences(this)

        syncDashboard.setOnClickListener {
            fetchDashboard()
        }

        dashboard.layoutManager = GridLayoutManager(this, 3)
        dashboard.setHasFixedSize(true)
        viewAdapter = DashboardItemsAdapter(this, dashboardArray)
        dashboard.adapter = viewAdapter

        dashboard.addOnItemTouchListener(RecyclerItemClickListener(this, dashboard,
            object : RecyclerItemClickListener.OnItemClickListener{

                override fun onItemClick(view: View, position: Int) {
                    doAction(position)
                }
                override fun onItemLongClick(view: View?, position: Int) {
                    TODO("do nothing")
                }
            }))

        // apply condition if first time only then execute below code
        if(prefs.getDashBoardData()!!.isEmpty()) {
            fetchDashboard()
        } else {
            onVolleySuccess(prefs.getDashBoardData()!!, ServiceManager.DASHBOARD_REQUEST_NUMBER)
        }
    }

    private fun fetchDashboard() {
        progress_circular.visibility = View.VISIBLE
        ServiceManager.makeStringRequest(this, Request.Method.GET, this,
            ServiceManager.DASHBOARD_REQUEST_NUMBER, ApiUrls.DASHBOARD_URL)
    }

    override fun onVolleyError(error: String?) {
        progress_circular.visibility = View.GONE
        Utils.showCustomToast(
            this, "Server error", Constants.TOAST_ERROR
        )
    }

    override fun onVolleySuccess(response: String, requestNumber: Int) {
        println("Dashboard  $response")
        progress_circular.visibility = View.GONE
        if (requestNumber == ServiceManager.DASHBOARD_REQUEST_NUMBER) run {
            val gson = Gson()
            val listType = object : TypeToken<java.util.ArrayList<DashBoardData>>() {
            }.type

            prefs.saveDashboardData(response)

            dashboardArray = gson.fromJson(response, listType)

            viewAdapter.setItems(dashboardArray)

        }
    }

    private fun doAction(position: Int) {
        if(dashboardArray.get(position).action.equals("redirect", true)) run {
            openDefaultBrowser(dashboardArray.get(position).service_name)
        } else run {
            openListActivity(dashboardArray.get(position))
        }
    }

    private fun openListActivity(data: DashBoardData) {
        val openActivity = Intent(this, ListViewActivity::class.java)
        openActivity.putExtra("api", data.service_name)
        openActivity.putExtra("title", data.menu_name)
        openActivity.putExtra("action", data.action)
        startActivity(openActivity)
    }

    private fun openDefaultBrowser(service_name: String) {
        val openURL = Intent(Intent.ACTION_VIEW)
        openURL.data = Uri.parse(service_name)
        startActivity(openURL)
    }

}
