//
//  SearchResultModel.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/20.
//

import Foundation

struct SearchResultModel : Codable {
    let isGameCenterEnabled : Bool?
    let advisories : [String]?
    let features : [String]?
    let supportedDevices : [String]?
    let screenshotUrls : [String]?
    let ipadScreenshotUrls : [String]?
    let artworkUrl60 : String?
    let artworkUrl512 : String?
    let artworkUrl100 : String?
    let artistViewUrl : String?
    let appletvScreenshotUrls : [String]?
    let kind : String?
    let releaseNotes : String?
    let artistId : Int?
    let artistName : String?
    let genres : [String]?
    let price : Double?
    let description : String?
    let isVppDeviceBasedLicensingEnabled : Bool?
    let bundleId : String?
    let primaryGenreName : String?
    let primaryGenreId : Int?
    let trackId : Int?
    let trackName : String?
    let releaseDate : String?
    let sellerName : String?
    let genreIds : [String]?
    let currentVersionReleaseDate : String?
    let currency : String?
    let minimumOsVersion : String?
    let trackCensoredName : String?
    let languageCodesISO2A : [String]?
    let fileSizeBytes : String?
    let formattedPrice : String?
    let contentAdvisoryRating : String?
    let averageUserRatingForCurrentVersion : Double?
    let userRatingCountForCurrentVersion : Int?
    let averageUserRating : Double?
    let trackViewUrl : String?
    let trackContentRating : String?
    let version : String?
    let wrapperType : String?
    let userRatingCount : Int?

    enum CodingKeys: String, CodingKey {

        case isGameCenterEnabled = "isGameCenterEnabled"
        case advisories = "advisories"
        case features = "features"
        case supportedDevices = "supportedDevices"
        case screenshotUrls = "screenshotUrls"
        case ipadScreenshotUrls = "ipadScreenshotUrls"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl512 = "artworkUrl512"
        case artworkUrl100 = "artworkUrl100"
        case artistViewUrl = "artistViewUrl"
        case appletvScreenshotUrls = "appletvScreenshotUrls"
        case kind = "kind"
        case releaseNotes = "releaseNotes"
        case artistId = "artistId"
        case artistName = "artistName"
        case genres = "genres"
        case price = "price"
        case description = "description"
        case isVppDeviceBasedLicensingEnabled = "isVppDeviceBasedLicensingEnabled"
        case bundleId = "bundleId"
        case primaryGenreName = "primaryGenreName"
        case primaryGenreId = "primaryGenreId"
        case trackId = "trackId"
        case trackName = "trackName"
        case releaseDate = "releaseDate"
        case sellerName = "sellerName"
        case genreIds = "genreIds"
        case currentVersionReleaseDate = "currentVersionReleaseDate"
        case currency = "currency"
        case minimumOsVersion = "minimumOsVersion"
        case trackCensoredName = "trackCensoredName"
        case languageCodesISO2A = "languageCodesISO2A"
        case fileSizeBytes = "fileSizeBytes"
        case formattedPrice = "formattedPrice"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case averageUserRatingForCurrentVersion = "averageUserRatingForCurrentVersion"
        case userRatingCountForCurrentVersion = "userRatingCountForCurrentVersion"
        case averageUserRating = "averageUserRating"
        case trackViewUrl = "trackViewUrl"
        case trackContentRating = "trackContentRating"
        case version = "version"
        case wrapperType = "wrapperType"
        case userRatingCount = "userRatingCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isGameCenterEnabled = try values.decodeIfPresent(Bool.self, forKey: .isGameCenterEnabled)
        advisories = try values.decodeIfPresent([String].self, forKey: .advisories)
        features = try values.decodeIfPresent([String].self, forKey: .features)
        supportedDevices = try values.decodeIfPresent([String].self, forKey: .supportedDevices)
        screenshotUrls = try values.decodeIfPresent([String].self, forKey: .screenshotUrls)
        ipadScreenshotUrls = try values.decodeIfPresent([String].self, forKey: .ipadScreenshotUrls)
        artworkUrl60 = try values.decodeIfPresent(String.self, forKey: .artworkUrl60)
        artworkUrl512 = try values.decodeIfPresent(String.self, forKey: .artworkUrl512)
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
        artistViewUrl = try values.decodeIfPresent(String.self, forKey: .artistViewUrl)
        appletvScreenshotUrls = try values.decodeIfPresent([String].self, forKey: .appletvScreenshotUrls)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        releaseNotes = try values.decodeIfPresent(String.self, forKey: .releaseNotes)
        artistId = try values.decodeIfPresent(Int.self, forKey: .artistId)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
        genres = try values.decodeIfPresent([String].self, forKey: .genres)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        isVppDeviceBasedLicensingEnabled = try values.decodeIfPresent(Bool.self, forKey: .isVppDeviceBasedLicensingEnabled)
        bundleId = try values.decodeIfPresent(String.self, forKey: .bundleId)
        primaryGenreName = try values.decodeIfPresent(String.self, forKey: .primaryGenreName)
        primaryGenreId = try values.decodeIfPresent(Int.self, forKey: .primaryGenreId)
        trackId = try values.decodeIfPresent(Int.self, forKey: .trackId)
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        sellerName = try values.decodeIfPresent(String.self, forKey: .sellerName)
        genreIds = try values.decodeIfPresent([String].self, forKey: .genreIds)
        currentVersionReleaseDate = try values.decodeIfPresent(String.self, forKey: .currentVersionReleaseDate)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        minimumOsVersion = try values.decodeIfPresent(String.self, forKey: .minimumOsVersion)
        trackCensoredName = try values.decodeIfPresent(String.self, forKey: .trackCensoredName)
        languageCodesISO2A = try values.decodeIfPresent([String].self, forKey: .languageCodesISO2A)
        fileSizeBytes = try values.decodeIfPresent(String.self, forKey: .fileSizeBytes)
        formattedPrice = try values.decodeIfPresent(String.self, forKey: .formattedPrice)
        contentAdvisoryRating = try values.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        averageUserRatingForCurrentVersion = try values.decodeIfPresent(Double.self, forKey: .averageUserRatingForCurrentVersion)
        userRatingCountForCurrentVersion = try values.decodeIfPresent(Int.self, forKey: .userRatingCountForCurrentVersion)
        averageUserRating = try values.decodeIfPresent(Double.self, forKey: .averageUserRating)
        trackViewUrl = try values.decodeIfPresent(String.self, forKey: .trackViewUrl)
        trackContentRating = try values.decodeIfPresent(String.self, forKey: .trackContentRating)
        version = try values.decodeIfPresent(String.self, forKey: .version)
        wrapperType = try values.decodeIfPresent(String.self, forKey: .wrapperType)
        userRatingCount = try values.decodeIfPresent(Int.self, forKey: .userRatingCount)
    }

}
