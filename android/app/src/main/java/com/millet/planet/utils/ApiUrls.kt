package com.millet.planet.utils

class ApiUrls {
    companion object {

        private const val PRODUCTION : String = "https://"

        private const val DEVELOPMENT : String = "http://dev-"

        private const val BASE_URL : String = "${PRODUCTION}services.milletplanet.org/sdmobile/api/v1.0"

        const val DASHBOARD_URL:String = "$BASE_URL/menu"

    }
}