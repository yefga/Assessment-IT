//
//  PexelsEntities.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 05/11/23.
//

import Foundation

// MARK: - Temperatures
struct PexelsModel: Codable, Equatable {
    let page, perPage: Int?
    let photos: [PhotoModel]?
    let totalResults: Int?
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}

// MARK: - Photo
struct PhotoModel: Codable, Equatable {
    let id, width, height: Int?
    let url: String?
    let photographer: String?
    let photographerURL: String?
    let photographerID: Int?
    let avgColor: String?
    let src: SrcModel?
    let liked: Bool?
    let alt: String?
    var isFavorite: Bool = false
    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
        case src, liked, alt
    }
}

// MARK: - Src
struct SrcModel: Codable, Equatable {
    let original, large2X, large, medium: String?
    let small, portrait, landscape, tiny: String?

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }
}
