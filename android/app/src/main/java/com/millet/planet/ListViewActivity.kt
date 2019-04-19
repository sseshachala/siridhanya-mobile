package com.millet.planet

import android.app.Dialog
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.text.Html
import android.text.method.ScrollingMovementMethod
import android.view.View
import android.view.Window
import android.widget.ImageView
import android.widget.TextView
import com.android.volley.Request
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.millet.planet.adapters.*
import com.millet.planet.listeners.PaginationScrollListener
import com.millet.planet.listeners.VolleyCallback
import com.millet.planet.models.*
import com.millet.planet.services.ServiceManager
import com.millet.planet.utils.Constants
import com.millet.planet.utils.Utils
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.activity_list_view.*
import org.json.JSONObject
import java.util.ArrayList
import android.text.Spannable
import com.millet.planet.customViews.textviews.PicassoImageGetter



class ListViewActivity : AppCompatActivity(), VolleyCallback {

    lateinit var faqAdapter: FAQItemsAdapter
    lateinit var globalJsonAdapter: GlobalJsonItemsAdapter
    lateinit var kidsInstructionItemsAdapter: KidsInstructionItemsAdapter
    lateinit var lifestyleItemsAdapter: LifestyleItemsAdapter

    var isLastPage: Boolean = false
    var isLoading: Boolean = false
    var nextPageURL: String? = ""
    var faqMainArray = ArrayList<FAQData>()
    var globalJsonArray = ArrayList<GlobalJsonData>()
    var kidsInstructionArray = ArrayList<KidsInstructionData>()
    var lifestyleArray = ArrayList<LifestyleData>()

    lateinit var layoutManagerMain: LinearLayoutManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list_view)

        val i = intent

        pageTitle.text = i.getStringExtra("title")

        var apiURL = i.getStringExtra("api")

        var action = i.getStringExtra("action")

        backToDashboard.setOnClickListener {
            finish()
        }

        layoutManagerMain = LinearLayoutManager(this)

//        if (action.equals("global", true)) {
//            aboutView.visibility = View.VISIBLE
//            fetchData(apiURL, ServiceManager.GLOBAL_JSON_REQUEST_NUMBER)
//            recyclerView.visibility = View.GONE
//        } else {
            if (pageTitle.text.toString().equals("About Doctor Khader Vali", true)) {
                aboutView.visibility = View.VISIBLE
                fetchData(apiURL, ServiceManager.ABOUT_REQUEST_NUMBER)
                recyclerView.visibility = View.GONE
            } else {
                aboutView.visibility = View.GONE
                recyclerView.visibility = View.VISIBLE
                recyclerView.layoutManager = layoutManagerMain
                recyclerView.setHasFixedSize(true)

                makeWebServiceCall(apiURL, pageTitle.text.toString())
            }
//        }

    }

    private fun makeWebServiceCall(apiURL: String?, type : String?) {
        var requestNumber : Int = 0
        if(type.equals("Kids Instructions", true)){
            requestNumber = ServiceManager.KIDS_INSTRUCTION_REQUEST_NUMBER
            nextPageURL = apiURL

            applyScrollListener(requestNumber)
        } else if (type.equals("Lifestyle", true)){
            requestNumber = ServiceManager.LIFESTYLE_REQUEST_NUMBER
            nextPageURL = apiURL

            applyScrollListener(requestNumber)
        } else if (type.equals("Millet Diet For Diseases", true)){
            requestNumber = ServiceManager.DISEASE_DIET_REQUEST_NUMBER
        }  else if (type.equals("Millet Diet For Cancer", true)){
            requestNumber = ServiceManager.CANCER_DIET_REQUEST_NUMBER
        }   else if (type.equals("Millet Nutrition", true)){
            requestNumber = ServiceManager.MILLET_NUTRITION_REQUEST_NUMBER
        }  else if (type.equals("Millet FAQ", true)){
            requestNumber = ServiceManager.FAQ_REQUEST_NUMBER
            nextPageURL = apiURL

            applyScrollListener(requestNumber)
        } else {
            requestNumber = ServiceManager.GLOBAL_JSON_REQUEST_NUMBER
            nextPageURL = apiURL

            applyScrollListener(requestNumber)
        }

        if (apiURL != null) {
            fetchData(apiURL, requestNumber)
        }
    }

    private fun applyScrollListener(requestNumber: Int) {

        recyclerView?.addOnScrollListener(object : PaginationScrollListener(layoutManagerMain) {
            override fun isLastPage(): Boolean {
                return isLastPage
            }

            override fun isLoading(): Boolean {
                return isLoading
            }

            override fun loadMoreItems() {
                isLoading = true
                //you have to call loadmore items to get more data
                if (nextPageURL != null) {
                    if(!nextPageURL!!.isEmpty() && !isLastPage) {
                        fetchData(nextPageURL!!, requestNumber)
                    }
                }
            }
        })

        if(requestNumber == ServiceManager.GLOBAL_JSON_REQUEST_NUMBER) {
            globalJsonAdapter = GlobalJsonItemsAdapter(this, globalJsonArray)
            recyclerView.adapter = globalJsonAdapter
        } else if (requestNumber == ServiceManager.KIDS_INSTRUCTION_REQUEST_NUMBER) {
            kidsInstructionItemsAdapter = KidsInstructionItemsAdapter(this, kidsInstructionArray)
            recyclerView.adapter = kidsInstructionItemsAdapter
        } else if(requestNumber == ServiceManager.LIFESTYLE_REQUEST_NUMBER) {
            lifestyleItemsAdapter = LifestyleItemsAdapter(this, lifestyleArray)
            recyclerView.adapter = lifestyleItemsAdapter
        } else {
            faqAdapter = FAQItemsAdapter(this, faqMainArray)
            recyclerView.adapter = faqAdapter
        }

    }

    private fun fetchData(url: String, requestNumber: Int) {
        ServiceManager.makeStringRequest(this, Request.Method.GET, this,
            requestNumber, url)
    }


    override fun onVolleySuccess(response: String, requestNumber: Int) {
        if (requestNumber == ServiceManager.ABOUT_REQUEST_NUMBER) run {
            var gson = Gson()
            val listType = object : TypeToken<ArrayList<AboutData>>() {
            }.type
            var aboutDataArray: ArrayList<AboutData>
            aboutDataArray = gson.fromJson(response, listType)

            var aboutData: AboutData = aboutDataArray.get(0)

            aboutRenderedText.text = aboutData.about

            aboutRenderedText.movementMethod = ScrollingMovementMethod()

            if(aboutData.image != "") {
                Picasso.with(this).load(aboutData.image).into(aboutImage)
            }
        } else if (requestNumber == ServiceManager.KIDS_INSTRUCTION_REQUEST_NUMBER) {

            isLoading = false

            val jsonObj = JSONObject(response)

            nextPageURL = jsonObj.getString("next_page_url")

            if(nextPageURL == null || nextPageURL!!.isEmpty() || nextPageURL.equals("null", true)) {
                isLastPage = true
            }

            val jsonArray = jsonObj.getJSONArray("data")

            var gson = Gson()
            val listType = object : TypeToken<ArrayList<KidsInstructionData>>() {
            }.type
            var kidsDataArray: ArrayList<KidsInstructionData> = gson.fromJson(jsonArray.toString(), listType)

            kidsInstructionArray.addAll(kidsDataArray)

            kidsInstructionItemsAdapter.sendData(kidsInstructionArray)

        } else if (requestNumber == ServiceManager.LIFESTYLE_REQUEST_NUMBER) {

            isLoading = false

            val jsonObj = JSONObject(response)

            nextPageURL = jsonObj.getString("next_page_url")

            if(nextPageURL == null || nextPageURL!!.isEmpty() || nextPageURL.equals("null", true)) {
                isLastPage = true
            }

            val jsonArray = jsonObj.getJSONArray("data")

            var gson = Gson()
            val listType = object : TypeToken<ArrayList<LifestyleData>>() {
            }.type
            var lifestyleDataArray: ArrayList<LifestyleData> = gson.fromJson(jsonArray.toString(), listType)

            lifestyleArray.addAll(lifestyleDataArray)

            lifestyleItemsAdapter.sendData(lifestyleArray)

        } else if  (requestNumber == ServiceManager.DISEASE_DIET_REQUEST_NUMBER) {
            var gson = Gson()
            val listType = object : TypeToken<ArrayList<MilletDiseasesDietData>>() {
            }.type
            var diseaseDataArray: ArrayList<MilletDiseasesDietData> = gson.fromJson(response, listType)

            var viewAdapter = DiesaseDietItemsAdapter(this, diseaseDataArray)
            recyclerView.adapter = viewAdapter
        } else if  (requestNumber == ServiceManager.CANCER_DIET_REQUEST_NUMBER) {
            var gson = Gson()
            val listType = object : TypeToken<ArrayList<MilletCancerDietData>>() {
            }.type
            var cancerDataArray: ArrayList<MilletCancerDietData> = gson.fromJson(response, listType)

            var viewAdapter = CancerDietItemsAdapter(this, cancerDataArray)
            recyclerView.adapter = viewAdapter
        } else if  (requestNumber == ServiceManager.FAQ_REQUEST_NUMBER) {

            isLoading = false

            val jsonObj = JSONObject(response)

            nextPageURL = jsonObj.getString("next_page_url")

            if(nextPageURL == null || nextPageURL!!.isEmpty() || nextPageURL.equals("null", true)) {
                isLastPage = true
            }

            val jsonArray = jsonObj.getJSONArray("data")

            var gson = Gson()
            val listType = object : TypeToken<ArrayList<FAQData>>() {
            }.type
            var faqDataArray: ArrayList<FAQData> = gson.fromJson(jsonArray.toString(), listType)

            faqMainArray.addAll(faqDataArray)

            faqAdapter.sendData(faqMainArray)

        }  else if  (requestNumber == ServiceManager.MILLET_NUTRITION_REQUEST_NUMBER) {
            var gson = Gson()
            val listType = object : TypeToken<ArrayList<MilletNutritionData>>() {
            }.type
            var nutritionDataArray: ArrayList<MilletNutritionData> = gson.fromJson(response, listType)

            var viewAdapter = MilletNutritionItemsAdapter(this, nutritionDataArray)
            recyclerView.adapter = viewAdapter
        } else if  (requestNumber == ServiceManager.GLOBAL_JSON_REQUEST_NUMBER) {

            isLoading = false

            val jsonObj = JSONObject(response)

            nextPageURL = jsonObj.getString("next_page_url")

            if(nextPageURL == null || nextPageURL!!.isEmpty() || nextPageURL.equals("null", true)) {
                isLastPage = true
            }

            val jsonArray = jsonObj.getJSONArray("data")

            var gson = Gson()
            val listType = object : TypeToken<ArrayList<GlobalJsonData>>() {
            }.type
            var globalDataArray: ArrayList<GlobalJsonData> = gson.fromJson(jsonArray.toString(), listType)

            globalJsonArray.addAll(globalDataArray)

            globalJsonAdapter.sendData(globalJsonArray)

        }
    }

    override fun onVolleyError(error: String?) {
        Utils.showCustomToast(
            this, "Server error", Constants.TOAST_ERROR
        )
    }

    fun showQuestion(data: FAQData) {
        var dialogs = Dialog(this)
        dialogs.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialogs.setCancelable(false)
        dialogs.setContentView(R.layout.answer_dialog)
        dialogs.getWindow()!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))

        val itemQuestion = dialogs.findViewById(R.id.itemQuestion) as TextView
        itemQuestion.text = data.question

        val yesBtn = dialogs.findViewById(R.id.closeDialog) as ImageView
        yesBtn.setOnClickListener {
            dialogs.dismiss()
        }

        val itemAnswer = dialogs.findViewById(R.id.itemAnswer) as TextView
//        itemAnswer.text = Html.fromHtml(data.answer)

        var answer = data.answer

        itemAnswer.movementMethod = ScrollingMovementMethod()

        val itemCount = dialogs.findViewById(R.id.itemCount) as ImageView

        if(!data.question_icon.isEmpty()) {
            Picasso.with(this).load(data.question_icon).into(itemCount)
        }

        val answerImage = dialogs.findViewById(R.id.answerImage) as ImageView

        if(!data.answer_icon.isEmpty()) {
            Picasso.with(this).load(data.answer_icon).into(answerImage)
        }

        val imageGetter = PicassoImageGetter(itemAnswer, this)
        val html: Spannable
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            html = Html.fromHtml(answer, Html.FROM_HTML_MODE_LEGACY, imageGetter, null) as Spannable
        } else {
            html = Html.fromHtml(answer, imageGetter, null) as Spannable
        }
        itemAnswer.setText(html)

        dialogs.show()
    }


}
