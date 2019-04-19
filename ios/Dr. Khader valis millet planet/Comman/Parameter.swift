
import Foundation



let AppURL = "http://198.211.112.4/sdmobile/api/"
//let kMenu = "http://198.211.112.4/sdmobile/api/menu"
let kMenu = "https://services.milletplanet.org/sdmobile/api/menu"





let kDashBoardData = "DashBoardData"
let KDeviceToken = "device_token"
let KAppName = "Dr. Khader vali's Millet Planet"
let KTokenExpired = "Token Expired."
let KInternetOffline = "The Internet connection appears to be offline."
let kJSONserializError = "JSON could not be serialized because of error"
let KServerNotresponding = "Server is not responding."
let KSessionExpired = "Your session is expired."
let kEventJoined = "Event is already joined by you."
let kEventJoinedRequestNotCompleted = "Event joined request not completed. Please try again."

typealias CompletionHandler = (_ data: AnyObject, _ success:Bool) -> Void
typealias UploadPercentHandler = (_ percentage : String) -> Void

//MARK: Enum
enum PickerType {
    case picker, date
}


